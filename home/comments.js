// comments.js
import { initializeApp } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-app.js";
import { getFirestore, collection, addDoc, serverTimestamp, query, orderBy, onSnapshot } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-firestore.js";
import { getAuth, signOut, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";

const firebaseConfig = {
    apiKey: "AIzaSyDxoIs6Nn5dMCpPj8JjNqbv-O3SVpiac0A",
    authDomain: "login-6cdd8.firebaseapp.com",
    projectId: "login-6cdd8",
    storageBucket: "login-6cdd8.firebasestorage.app",
    messagingSenderId: "518535069226",
    appId: "1:518535069226:web:8925106a250805bbf24d53"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

const loginBtn = document.getElementById('login-btn');
const logoutBtn = document.getElementById('logout-btn');
const commentForm = document.getElementById('comment-form');
const commentsDiv = document.getElementById('comments');
const commentInput = document.getElementById('comment-input');
const userInfoDiv = document.getElementById('user-info');

loginBtn.onclick = () => location.href = "signin.html";
logoutBtn.onclick = () => signOut(auth);

onAuthStateChanged(auth, user => {
    if (user) {
        loginBtn.style.display = 'none';
        logoutBtn.style.display = 'inline-block';
        commentForm.style.display = 'block';
        userInfoDiv.textContent = `Logged in as ${user.email || user.displayName}`;
    } else {
        loginBtn.style.display = 'inline-block';
        logoutBtn.style.display = 'none';
        commentForm.style.display = 'none';
        userInfoDiv.textContent = '';
    }
});

commentForm.onsubmit = async (e) => {
    e.preventDefault();
    await addDoc(collection(db, "comments"), {
        text: commentInput.value,
        timestamp: serverTimestamp(),
        username: auth.currentUser.email || auth.currentUser.displayName
    });
    commentInput.value = '';
};

const q = query(collection(db, "comments"), orderBy("timestamp", "desc"));
onSnapshot(q, (snapshot) => {
    commentsDiv.innerHTML = '';
    snapshot.forEach(doc => {
        const cmt = doc.data();
        commentsDiv.innerHTML += `<div><b>${cmt.username}</b>: ${cmt.text}</div>`;
    });
});
