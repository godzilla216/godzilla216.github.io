// comments.js
import { db, auth } from './index.html';
import { collection, addDoc, serverTimestamp, query, orderBy, onSnapshot } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-firestore.js";
import { GoogleAuthProvider, signInWithPopup, signOut, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";

const loginBtn = document.getElementById('login-btn');
const logoutBtn = document.getElementById('logout-btn');
const commentForm = document.getElementById('comment-form');
const commentInput = document.getElementById('comment-input');
const commentsDiv = document.getElementById('comments');
const userInfoDiv = document.getElementById('user-info');

const provider = new GoogleAuthProvider();

// Login with Google
loginBtn.addEventListener('click', () => {
    signInWithPopup(auth, provider)
    .then(result => {
        console.log('Logged in:', result.user.displayName);
    })
    .catch(err => {
        console.error('Login error:', err.message);
    });
});

// Logout
logoutBtn.addEventListener('click', () => {
    signOut(auth).then(() => {
        console.log('User signed out.');
    });
});

// Handle Auth State
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

// Post Comment to Firestore
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
        alert('You must be signed in to comment.');
    }
});

// Fetch Comments from Firestore
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
