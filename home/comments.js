// comments.js
import { initializeApp } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-app.js";
import { getFirestore, collection, addDoc, serverTimestamp, query, orderBy, onSnapshot } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-firestore.js";
import { getAuth, GoogleAuthProvider, signInWithPopup, signOut, createUserWithEmailAndPassword, signInWithEmailAndPassword, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";

// Your Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyDxoIs6Nn5dMCpPj8JjNqbv-O3SVpiac0A",
    authDomain: "login-6cdd8.firebaseapp.com",
    projectId: "login-6cdd8",
    storageBucket: "login-6cdd8.firebasestorage.app",
    messagingSenderId: "518535069226",
    appId: "1:518535069226:web:8925106a250805bbf24d53",
    measurementId: "G-5S5XBHDN02"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);
const provider = new GoogleAuthProvider();

// DOM Elements
const loginBtn = document.getElementById('login-btn');
const logoutBtn = document.getElementById('logout-btn');
const commentForm = document.getElementById('comment-form');
const commentsDiv = document.getElementById('comments');
const commentInput = document.getElementById('comment-input');
const userInfoDiv = document.getElementById('user-info');

// Google Login
loginBtn.addEventListener('click', () => {
    signInWithPopup(auth, provider).catch(err => {
        console.error("Google login error:", err);
    });
});

// Logout
logoutBtn.addEventListener('click', () => {
    signOut(auth).catch(err => {
        console.error("Logout error:", err);
    });
});

// Listen to auth state changes
onAuthStateChanged(auth, user => {
    if (user) {
        loginBtn.style.display = 'none';
        logoutBtn.style.display = 'inline-block';
        commentForm.style.display = 'block';
        userInfoDiv.textContent = `Logged in as ${user.displayName || user.email}`;
    } else {
        loginBtn.style.display = 'inline-block';
        logoutBtn.style.display = 'none';
        commentForm.style.display = 'none';
        userInfoDiv.textContent = '';
    }
});

// Comment Submission
commentForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    if (auth.currentUser) {
        await addDoc(collection(db, "comments"), {
            text: commentInput.value,
            timestamp: serverTimestamp(),
            username: auth.currentUser.displayName || auth.currentUser.email,
            userId: auth.currentUser.uid
        });
        commentInput.value = '';
    }
});

// Load Comments
import { collection, addDoc, query, orderBy, onSnapshot, serverTimestamp } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-firestore.js";

const commentsRef = collection(db, "comments");
const q = query(commentsRef, orderBy("timestamp", "desc"));

onSnapshot(q, snapshot => {
    commentsDiv.innerHTML = '';
    snapshot.forEach(doc => {
        const comment = doc.data();
        const commentEl = document.createElement('div');
        commentEl.innerHTML = `<strong>${comment.username}:</strong> ${comment.text}`;
        commentsDiv.appendChild(commentEl);
    });
});

// Email/Password Authentication (Optional)
// If you want users to sign up or log in with email/password, use this additional code:

const emailSignup = document.getElementById('email-signup');
const emailInput = document.getElementById('email-input');
const passwordInput = document.getElementById('password-input');
const signupBtn = document.getElementById('signup-btn');
const signinBtn = document.getElementById('signin-btn');

signupBtn.addEventListener('click', () => {
    signInWithEmailAndPassword(auth, emailInput.value, passwordInput.value)
        .catch(err => alert(err.message));
});

signinBtn.addEventListener('click', () => {
    signInWithEmailAndPassword(auth, emailInput.value, passwordInput.value)
        .catch(err => alert(err.message));
});
