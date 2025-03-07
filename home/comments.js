// Import Firebase Modules
import { initializeApp } from 'https://www.gstatic.com/firebasejs/9.10.0/firebase-app.js';
import { getAuth, GoogleAuthProvider, signInWithPopup, signOut, 
         onAuthStateChanged, createUserWithEmailAndPassword, signInWithEmailAndPassword } 
    from 'https://www.gstatic.com/firebasejs/9.10.0/firebase-auth.js';
import { getFirestore, collection, addDoc, query, orderBy, onSnapshot } 
    from 'https://www.gstatic.com/firebasejs/9.10.0/firebase-firestore.js';

// ✅ Use the same Firebase project
const firebaseConfig = {
    apiKey: "AIzaSyDxoIs6Nn5dMCpPj8JjNqbv-O3SVpiac0A",
    authDomain: "login-6cdd8.firebaseapp.com",
    projectId: "login-6cdd8",
    storageBucket: "login-6cdd8.appspot.com",
    messagingSenderId: "518535069226",
    appId: "1:518535069226:web:8925106a250805bbf24d53",
    measurementId: "G-5S5XBHDN02"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

// Select UI Elements
const googleLoginButton = document.getElementById("googleLoginButton");
const emailLoginButton = document.getElementById("emailLoginButton");
const signupButton = document.getElementById("signupButton");
const logoutButton = document.getElementById("logoutButton");

const emailInput = document.getElementById("emailInput");
const passwordInput = document.getElementById("passwordInput");

const commentSection = document.getElementById("commentSection");
const commentInput = document.getElementById("commentInput");
const postCommentButton = document.getElementById("postCommentButton");
const commentsDiv = document.getElementById("comments");

// ✅ Handle Authentication
googleLoginButton.addEventListener("click", () => {
    const provider = new GoogleAuthProvider();
    signInWithPopup(auth, provider);
});

emailLoginButton.addEventListener("click", async () => {
    await signInWithEmailAndPassword(auth, emailInput.value, passwordInput.value);
});

signupButton.addEventListener("click", async () => {
    await createUserWithEmailAndPassword(auth, emailInput.value, passwordInput.value);
});

logoutButton.addEventListener("click", () => {
    signOut(auth);
});

// ✅ Detect Auth State Changes
onAuthStateChanged(auth, (user) => {
    commentSection.style.display = user ? "block" : "none";
    logoutButton.style.display = user ? "block" : "none";
});

// ✅ Post & Load Comments in Real-Time
postCommentButton.addEventListener("click", async () => {
    await addDoc(collection(db, "comments"), {
        user: auth.currentUser.email,
        text: commentInput.value,
        timestamp: new Date()
    });
});

onSnapshot(query(collection(db, "comments"), orderBy("timestamp", "desc")), (snapshot) => {
    commentsDiv.innerHTML = snapshot.docs.map(doc => `<p><b>${doc.data().user}:</b> ${doc.data().text}</p>`).join("");
});
