import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth, signInAnonymously } from 'firebase/auth';

// Firebase configuration
// IMPORTANT: Replace these values with your actual Firebase project credentials
const firebaseConfig = {
  apiKey: "AIzaSyC2rbVs2H-VoX5O0r2nvbAwCmSoAz_0GBU",
  authDomain: "phasmophobia-saves.firebaseapp.com",
  projectId: "phasmophobia-saves",
  storageBucket: "phasmophobia-saves.firebasestorage.app",
  messagingSenderId: "1046174653253",
  appId: "1:1046174653253:web:52e7d4c8427898d6ecfc2c",
  measurementId: "G-76TEQVXRT8"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firestore
export const db = getFirestore(app);

// Initialize Auth
export const auth = getAuth(app);

// Sign in anonymously
export const signInAnonymous = async () => {
  try {
    await signInAnonymously(auth);
    console.log('Signed in anonymously');
    return true;
  } catch (error) {
    console.error('Error signing in anonymously:', error);
    return false;
  }
};

