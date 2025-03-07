// Import Firebase Modules
import { initializeApp } from 'https://www.gstatic.com/firebasejs/9.10.0/firebase-app.js';
import { getAuth, GoogleAuthProvider, signInWithPopup, signOut, 
         onAuthStateChanged, createUserWithEmailAndPassword, signInWithEmailAndPassword } 
    from 'https://www.gstatic.com/firebasejs/9.10.0/firebase-auth.js';
import { getFirestore, collection, addDoc, query, orderBy, onSnapshot } 
    from 'https://www.gstatic.com/firebasejs/9.10.0/firebase-firestore.js';

// ✅ Use the same Firebase config as your main app
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

// ✅ Handle Google Authentication
googleLoginButton.addEventListener("click", () => {
    const provider = new GoogleAuthProvider();
    signInWithPopup(auth, provider).catch(error => console.error("❌ Google Login Error:", error));
});

// ✅ Handle Email/Password Login
emailLoginButton.addEventListener("click", async () => {
    const email = emailInput.value;
    const password = passwordInput.value;

    try {
        await signInWithEmailAndPassword(auth, email, password);
        console.log("✅ Email login successful:", email);
    } catch (error) {
        console.error("❌ Email login failed:", error.message);
        alert("Login failed: " + error.message);
    }
});

// ✅ Handle User Signup
signupButton.addEventListener("click", async () => {
    const email = emailInput.value;
    const password = passwordInput.value;

    try {
        await createUserWithEmailAndPassword(auth, email, password);
        console.log("✅ User signed up:", email);
        alert("Signup successful! Please log in.");
    } catch (error) {
        console.error("❌ Signup error:", error.message);
        alert("Signup failed: " + error.message);
    }
});

// ✅ Handle Logout
logoutButton.addEventListener("click", () => {
    signOut(auth).catch(error => console.error("❌ Logout Error:", error));
});

// ✅ Detect Auth State Changes
onAuthStateChanged(auth, (user) => {
    if (user) {
        console.log("✅ Logged in as:", user.email);
        googleLoginButton.style.display = "none";
        emailLoginButton.style.display = "none";
        signupButton.style.display = "none";
        logoutButton.style.display = "inline";
        commentSection.style.display = "block";
        loadComments();
    } else {
        console.log("❌ User logged out.");
        googleLoginButton.style.display = "inline";
        emailLoginButton.style.display = "inline";
        signupButton.style.display = "inline";
        logoutButton.style.display = "none";
        commentSection.style.display = "none";
    }
});

// ✅ Post a New Comment
postCommentButton.addEventListener("click", async () => {
    const user = auth.currentUser;
    if (!user) return alert("⚠️ You must be logged in to post a comment!");

    const commentText = commentInput.value.trim();
    if (!commentText) return alert("⚠️ Comment cannot be empty!");

    try {
        await addDoc(collection(db, "comments"), {
            userId: user.uid,
            userName: user.email,
            text: commentText,
            timestamp: new Date()
        });
        console.log("✅ Comment added:", commentText);
        commentInput.value = "";
    } catch (error) {
        console.error("❌ Error posting comment:", error);
    }
});

// ✅ Load Comments in Real-Time
function loadComments() {
    commentsDiv.innerHTML = "<p>Loading comments...</p>";

    const q = query(collection(db, "comments"), orderBy("timestamp", "desc"));
    onSnapshot(q, (snapshot) => {
        commentsDiv.innerHTML = ""; // Clear previous comments
        snapshot.forEach((doc) => {
            const comment = doc.data();
            const commentElement = document.createElement("div");
            commentElement.classList.add("comment");
            commentElement.innerHTML = `<strong>${comment.userName}</strong>: ${comment.text}`;
            commentsDiv.appendChild(commentElement);
        });
        console.log("🔄 Comments updated.");
    });
}
