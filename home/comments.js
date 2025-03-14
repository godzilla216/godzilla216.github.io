// comments.js
import { initializeApp } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-app.js";
import {
    getFirestore, collection, addDoc,
    serverTimestamp, query, orderBy, onSnapshot
} from "https://www.gstatic.com/firebasejs/11.4.0/firebase-firestore.js";
import {
    getAuth, onAuthStateChanged, signOut
} from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";

// Your Firebase config
const firebaseConfig = {
    apiKey: "AIzaSyDxoIs6Nn5dMCpPj8JjNqbv-O3SVpiac0A",
    authDomain: "login-6cdd8.firebaseapp.com",
    projectId: "login-6cdd8",
    storageBucket: "login-6cdd8.firebasestorage.app",
    messagingSenderId: "518535069226",
    appId: "1:518535069226:web:8925106a250805bbf24d53"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

// DOM elements
const loginBtn = document.getElementById('login-btn');
const logoutBtn = document.getElementById('logout-btn');
const commentForm = document.getElementById('comment-form');
const commentInput = document.getElementById('comment-input');
const commentsDiv = document.getElementById('comments');
const userInfoDiv = document.getElementById('user-info');

// Redirect user to signin.html on login button click
loginBtn.onclick = () => location.href = "signin.html";

// Logout function
logoutBtn.onclick = () => signOut(auth);

// Auth state listener
onAuthStateChanged(auth, user => {
    if (user) {
        loginBtn.style.display = 'none';
        logoutBtn.style.display = 'inline-block';
        commentForm.style.display = 'block';
        userInfoDiv.innerHTML = `Logged in as ${user.displayName || user.email}`;
        
        // Load comments after sign-in
        loadComments();
    } else {
        loginBtn.style.display = 'inline-block';
        logoutBtn.style.display = 'none';
        commentForm.style.display = 'none';
        userInfoDiv.innerHTML = '';
        commentsDiv.innerHTML = '';
    }
});

// Comment submission
commentForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    await addDoc(collection(db, "comments"), {
        text: commentInput.value,
        timestamp: serverTimestamp(),
        username: auth.currentUser.displayName || auth.currentUser.email,
        userId: auth.currentUser.uid
    });
    commentInput.value = '';
});

// Real-time Comments function
function loadComments() {
    const q = query(collection(db, "comments"), orderBy("timestamp", "desc"));
    onSnapshot(q, snapshot => {
        commentsDiv.innerHTML = '';
        snapshot.forEach(doc => {
            const comment = doc.data();
            commentsDiv.innerHTML += `<div><strong>${comment.username}:</strong> ${comment.text}</div>`;
        });
}
}

// Logout functionality
logoutBtn.onclick = () => {
    signOut(auth).then(() => location.reload());
};
