// Import Firebase modules
import { initializeApp } from 'https://www.gstatic.com/firebasejs/9.10.0/firebase-app.js';
import { getAuth, createUserWithEmailAndPassword } from 'https://www.gstatic.com/firebasejs/9.10.0/firebase-auth.js';

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

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

// Form and error elements
const signupForm = document.getElementById('signupForm');
const errorMessage = document.getElementById('error-message');

// Handle form submission
signupForm.addEventListener('submit', async (e) => {
  e.preventDefault();
  
  // Correct input IDs
  const email = document.getElementById('signup-email').value;
  const password = document.getElementById('signup-password').value;

  try {
    const userCredential = await createUserWithEmailAndPassword(auth, email, password);
    console.log("User signed up:", userCredential);

    // Redirect
    window.location.href = "success.html"; // or index.html

  } catch (error) {
    console.error("Error during sign-up:", error.message);
    errorMessage.textContent = cleanErrorMessage(error.message);
  }
});

// Optional: Cleaner error messages
function cleanErrorMessage(msg) {
  if (msg.includes("Password should be at least 6 characters")) {
    return "Password must be 6+ characters!";
  }
  if (msg.includes("email-already-in-use")) {
    return "This email is already in use!";
  }
  return msg;
}
