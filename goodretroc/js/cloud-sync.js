// Firebase cloud save bridge for Retro Bowl HTML5 build.
// Configure Firebase by setting window.RBC_FIREBASE_CONFIG before this file loads,
// or by storing JSON in localStorage["rbc_firebase_config"].
(function () {
  "use strict";

  function readStoredFirebaseConfig() {
    try {
      var raw = window.localStorage.getItem("rbc_firebase_config");
      if (!raw) return null;
      return JSON.parse(raw);
    } catch (_e) {
      return null;
    }
  }

  function getFirebaseConfig() {
    if (window.RBC_FIREBASE_CONFIG) return window.RBC_FIREBASE_CONFIG;
    return readStoredFirebaseConfig();
  }

  function getStoragePrefix() {
    if (window.g_pBuiltIn && typeof window.g_pBuiltIn._PN2 === "string") {
      return window.g_pBuiltIn._PN2;
    }
    return "";
  }

  function resolveSaveStorageKey(saveName) {
    if (!saveName) return null;
    var direct = window.localStorage.getItem(saveName);
    if (direct !== null) return saveName;

    var suffix = String(saveName);
    for (var i = 0; i < window.localStorage.length; i += 1) {
      var k = window.localStorage.key(i);
      if (typeof k === "string" && (k === suffix || k.endsWith(suffix))) {
        return k;
      }
    }
    var prefixed = getStoragePrefix() + suffix;
    if (window.localStorage.getItem(prefixed) !== null) return prefixed;
    return prefixed;
  }

  function getSaveBlob(saveName) {
    var key = resolveSaveStorageKey(saveName);
    if (!key) return null;
    return window.localStorage.getItem(key);
  }

  function setSaveBlob(saveName, blob) {
    var key = resolveSaveStorageKey(saveName);
    if (!key) throw new Error("Could not resolve save key for " + saveName);
    window.localStorage.setItem(key, String(blob));
    return key;
  }

  var app = null;
  var auth = null;
  var db = null;
  var storage = null;
  var collectionName = "retroBowlSaves";
  var CHUNK_SIZE = 240000;

  function ensureFirebaseReady() {
    if (!window.firebase) {
      throw new Error("Firebase SDK not loaded.");
    }
    var cfg = getFirebaseConfig();
    if (!cfg || !cfg.apiKey) {
      throw new Error("Firebase config missing. Set window.RBC_FIREBASE_CONFIG.");
    }
    if (!app) {
      app = window.firebase.apps && window.firebase.apps.length ? window.firebase.app() : window.firebase.initializeApp(cfg);
      auth = window.firebase.auth();
      db = window.firebase.firestore();
      storage = window.firebase.storage();
    }
  }

  function currentUser() {
    ensureFirebaseReady();
    return auth.currentUser || null;
  }

  function requireUser() {
    var user = currentUser();
    if (!user) {
      throw new Error("Not logged in.");
    }
    return user;
  }

  async function loginGoogle() {
    ensureFirebaseReady();
    var provider = new window.firebase.auth.GoogleAuthProvider();
    try {
      var result = await auth.signInWithPopup(provider);
      return result && result.user ? { uid: result.user.uid, email: result.user.email || "", displayName: result.user.displayName || "" } : null;
    } catch (err) {
      var code = err && err.code ? String(err.code) : "";
      if (code === "auth/popup-blocked" || code === "auth/popup-closed-by-user" || code === "auth/cancelled-popup-request") {
        await auth.signInWithRedirect(provider);
        return null;
      }
      throw err;
    }
  }

  async function logout() {
    ensureFirebaseReady();
    await auth.signOut();
  }

  function saveDocRef(uid, saveName) {
    return db.collection("users").doc(uid).collection(collectionName).doc(String(saveName));
  }

  function saveObjectPath(uid, saveName) {
    var normalized = String(saveName);
    if (!/\.ini$/i.test(normalized)) {
      normalized += ".ini";
    }
    return "users/" + String(uid) + "/saves/" + encodeURIComponent(normalized);
  }

  function shouldPreferFirestoreChunks() {
    var host = (window.location && window.location.hostname ? window.location.hostname : "").toLowerCase();
    var proto = window.location && window.location.protocol ? window.location.protocol : "";
    if (host === "127.0.0.1" || host === "0.0.0.0") return true;
    if (proto !== "https:" && host !== "localhost") return true;
    return false;
  }

  async function writeFirestoreChunks(uid, saveName, payload) {
    var docRef = saveDocRef(uid, saveName);
    var chunksRef = docRef.collection("chunks");

    // Clear previous chunks to avoid stale data when payload shrinks.
    var old = await chunksRef.get();
    if (!old.empty) {
      var batchDel = db.batch();
      old.forEach(function (d) {
        batchDel.delete(d.ref);
      });
      await batchDel.commit();
    }

    var count = Math.ceil(payload.length / CHUNK_SIZE);
    for (var i = 0; i < count; i += 1) {
      var start = i * CHUNK_SIZE;
      var end = Math.min(start + CHUNK_SIZE, payload.length);
      var part = payload.slice(start, end);
      await chunksRef.doc(String(i)).set({
        idx: i,
        payload: part
      });
    }

    await docRef.set({
      saveName: String(saveName),
      format: "firestore_chunks",
      chunkCount: count,
      sizeBytes: payload.length,
      updatedAt: window.firebase.firestore.FieldValue.serverTimestamp(),
      updatedBy: uid
    }, { merge: true });
  }

  async function readFirestoreChunks(uid, saveName) {
    var docRef = saveDocRef(uid, saveName);
    var snap = await docRef.collection("chunks").orderBy("idx", "asc").get();
    if (snap.empty) return null;
    var out = "";
    snap.forEach(function (d) {
      var data = d.data() || {};
      out += data.payload || "";
    });
    return out;
  }

  async function uploadSaveByName(saveName) {
    ensureFirebaseReady();
    var user = requireUser();
    var blob = getSaveBlob(saveName);
    if (blob === null || blob === undefined || blob === "") {
      throw new Error("Local save not found for " + saveName);
    }
    var payload = String(blob);
    var path = saveObjectPath(user.uid, saveName);
    if (shouldPreferFirestoreChunks()) {
      await writeFirestoreChunks(user.uid, saveName, payload);
      return true;
    }
    try {
      var ref = storage.ref(path);
      await ref.putString(payload, "raw", { contentType: "text/plain;charset=utf-8" });
      await saveDocRef(user.uid, saveName).set({
        saveName: String(saveName),
        format: "storage",
        storagePath: path,
        sizeBytes: payload.length,
        updatedAt: window.firebase.firestore.FieldValue.serverTimestamp(),
        updatedBy: user.uid
      }, { merge: true });
    } catch (storageErr) {
      await writeFirestoreChunks(user.uid, saveName, payload);
    }
    return true;
  }

  async function downloadSaveByName(saveName) {
    ensureFirebaseReady();
    var user = requireUser();
    var snap = await saveDocRef(user.uid, saveName).get();
    if (!snap.exists) {
      return { ok: false, reason: "not_found" };
    }
    var data = snap.data() || {};
    if (data.payload) {
      var oldKey = setSaveBlob(saveName, data.payload);
      return { ok: true, key: oldKey, source: "firestore_legacy" };
    }
    if (data.format === "firestore_chunks" || data.chunkCount) {
      var joined = await readFirestoreChunks(user.uid, saveName);
      if (!joined) return { ok: false, reason: "chunk_not_found" };
      var ckey = setSaveBlob(saveName, joined);
      return { ok: true, key: ckey, source: "firestore_chunks" };
    }
    if (!data.storagePath) {
      return { ok: false, reason: "empty_payload" };
    }
    var url = await storage.ref(String(data.storagePath)).getDownloadURL();
    var res = await fetch(url);
    if (!res.ok) {
      throw new Error("Failed to download cloud save: HTTP " + res.status);
    }
    var payload = await res.text();
    var key = setSaveBlob(saveName, payload);
    return { ok: true, key: key, source: "storage" };
  }

  function isLoggedIn() {
    try {
      return !!currentUser();
    } catch (_e) {
      return false;
    }
  }

  function getUser() {
    var user = null;
    try {
      user = currentUser();
    } catch (_e) {
      user = null;
    }
    if (!user) return null;
    return { uid: user.uid, email: user.email || "", displayName: user.displayName || "" };
  }

  function setFirebaseConfig(config) {
    window.RBC_FIREBASE_CONFIG = config;
    try {
      window.localStorage.setItem("rbc_firebase_config", JSON.stringify(config || {}));
    } catch (_e) {
      // Ignore localStorage write failures.
    }
    app = null;
    auth = null;
    db = null;
    storage = null;
    return true;
  }

  window.RBCCloud = {
    isLoggedIn: isLoggedIn,
    getUser: getUser,
    loginGoogle: loginGoogle,
    logout: logout,
    uploadSaveByName: uploadSaveByName,
    downloadSaveByName: downloadSaveByName,
    setFirebaseConfig: setFirebaseConfig,
    resolveSaveStorageKey: resolveSaveStorageKey
  };
})();
