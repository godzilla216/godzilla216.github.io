// hitCounter.js
import { initializeApp } from "https://www.gstatic.com/firebasejs/11.6.1/firebase-app.js";
import { getFirestore, doc, getDoc, setDoc, updateDoc, increment } from "https://www.gstatic.com/firebasejs/11.6.1/firebase-firestore.js";

// Firebase config
const firebaseConfig = {
  apiKey: "AIzaSyDxoIs6Nn5dMCpPj8JjNqbv-O3SVpiac0A",
  authDomain: "login-6cdd8.firebaseapp.com",
  projectId: "login-6cdd8",
  storageBucket: "login-6cdd8.firebasestorage.app",
  messagingSenderId: "518535069226",
  appId: "1:518535069226:web:8925106a250805bbf24d53",
  measurementId: "G-5S5XBHDN02"
};

// Init Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Document path: counters/gameHomeHits
const counterDoc = doc(db, "counters", "gameHomeHits");

async function countHits() {
  const snap = await getDoc(counterDoc);
  if (snap.exists()) {
    await updateDoc(counterDoc, { hits: increment(1) });
  } else {
    await setDoc(counterDoc, { hits: 1 });
  }

  const updated = await getDoc(counterDoc);
  document.getElementById("hitCounter").textContent = updated.data().hits;
}

countHits();
