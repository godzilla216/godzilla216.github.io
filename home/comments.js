// comments.js
import { initializeApp } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-app.js";
import { getFirestore, collection, addDoc, serverTimestamp, query, orderBy, onSnapshot } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-firestore.js";
import { getAuth, GoogleAuthProvider, signInWithPopup, signOut, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";

// Firebase configuration (copy your existing configuration here)
const firebaseConfig = {
    apiKey: "AIzaSyDxoIs6Nn5dMCpPj8JjNqbv-O3SVpiac0A",
    authDomain: "login-6cdd8.firebaseapp.com",
    projectId: "login-6cdd8",
    storageBucket: "login-6cdd8.firebasestorage.app",
    messagingSenderId: "518535069226",
    appId: "1:518535069226:web:8925106a250805bbf24d53",
    measurementId: "G-5S5XBHDN02"
};

// Initialize Firebase directly here
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);
const provider = new GoogleAuthProvider();

// DOM Elements
const loginBtn = document.getElementById('login-btn');
const logoutBtn = document.getElementById('logout-btn');
const commentForm = document.getElementById('comment-form');
const commentInput = document.getElementById('comment-input');
const commentsDiv = document.getElementById('comments');
const userInfoDiv = document.getElementById('user-info');

// Google Login
loginBtn.addEventListener('click', () => {
    signInWithPopup(auth, provider)
    .then(result => {
        console.log('Logged in:', result.user.displayName);
    })
    .catch(err => {
        console.error('Login error:', err.message);
        alert(`Login failed: ${err.message}`);
    });
});

// Logout
logoutBtn.addEventListener('click', () => {
    signOut(auth).then(() => {
        console.log('User signed out.');
    });
});

// Auth State Observer
onAuthStateChanged(auth, user => {
    if (user) {
        loginBtn.style.display = 'none';
        logoutBtn.style.display = 'inline-block';
        commentForm.style.display = 'block';
        userInfoDiv.innerHTML = `Logged in as ${user.displayName}`;
    } else {
        loginBtn.style.display = 'inline-block';
        logoutBtn.style.display = 'none';
        commentForm.style.display = 'none';
        userInfoDiv.innerHTML = '';
    }
});

// Submit Comment
commentForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    if (auth.currentUser) {
        await addDoc(collection(db, "comments"), {
            text: commentInput.value,
            timestamp: serverTimestamp(),
            username: auth.currentUser.displayName,
            userId: auth.currentUser.uid
        });
        commentInput.value = '';
    } else {
        alert('Please log in to comment.');
    }
});

// Real-time Comment Updates
const q = query(collection(db, "comments"), orderBy("timestamp", "desc"));
onSnapshot(q, (snapshot) => {
    commentsDiv.innerHTML = '';
    snapshot.forEach(doc => {
        const comment = doc.data();
        const commentEl = document.createElement('div');
        commentEl.innerHTML = `<strong>${comment.username}</strong>: ${comment.text}`;
        commentsDiv.appendChild(commentEl);
    });
});
