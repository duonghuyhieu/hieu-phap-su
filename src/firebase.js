import { initializeApp } from 'firebase/app';
import {
  getFirestore,
  collection,
  addDoc,
  getDoc,
  getDocs,
  updateDoc,
  deleteDoc,
  doc,
  serverTimestamp,
  query,
  orderBy
} from 'firebase/firestore';
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

// Collection name for saves
const SAVES_COLLECTION = 'saves';

/**
 * Create a new save
 * @param {string} saveName - User-provided name for the save
 * @param {string} saveContent - The text content of the save file
 * @returns {Promise<string>} - The ID of the created save
 */
export const createSave = async (saveName, saveContent) => {
  try {
    const docRef = await addDoc(collection(db, SAVES_COLLECTION), {
      saveName,
      saveContent,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    });
    console.log('Save created with ID:', docRef.id);
    return docRef.id;
  } catch (error) {
    console.error('Error creating save:', error);
    throw error;
  }
};

/**
 * Get a save by ID
 * @param {string} saveId - The ID of the save to retrieve
 * @returns {Promise<Object>} - The save data with id
 */
export const getSave = async (saveId) => {
  try {
    const docRef = doc(db, SAVES_COLLECTION, saveId);
    const docSnap = await getDoc(docRef);

    if (docSnap.exists()) {
      return { id: docSnap.id, ...docSnap.data() };
    } else {
      throw new Error('Save not found');
    }
  } catch (error) {
    console.error('Error getting save:', error);
    throw error;
  }
};

/**
 * Get all saves
 * @returns {Promise<Array>} - Array of all saves
 */
export const getAllSaves = async () => {
  try {
    const q = query(collection(db, SAVES_COLLECTION), orderBy('createdAt', 'desc'));
    const querySnapshot = await getDocs(q);

    const saves = [];
    querySnapshot.forEach((doc) => {
      saves.push({ id: doc.id, ...doc.data() });
    });

    return saves;
  } catch (error) {
    console.error('Error getting saves:', error);
    throw error;
  }
};

/**
 * Update a save
 * @param {string} saveId - The ID of the save to update
 * @param {string} saveName - New name for the save (optional)
 * @param {string} saveContent - New content for the save (optional)
 * @returns {Promise<void>}
 */
export const updateSave = async (saveId, saveName, saveContent) => {
  try {
    const docRef = doc(db, SAVES_COLLECTION, saveId);
    const updateData = {
      updatedAt: serverTimestamp()
    };

    if (saveName !== undefined) updateData.saveName = saveName;
    if (saveContent !== undefined) updateData.saveContent = saveContent;

    await updateDoc(docRef, updateData);
    console.log('Save updated:', saveId);
  } catch (error) {
    console.error('Error updating save:', error);
    throw error;
  }
};

/**
 * Delete a save
 * @param {string} saveId - The ID of the save to delete
 * @returns {Promise<void>}
 */
export const deleteSave = async (saveId) => {
  try {
    const docRef = doc(db, SAVES_COLLECTION, saveId);
    await deleteDoc(docRef);
    console.log('Save deleted:', saveId);
  } catch (error) {
    console.error('Error deleting save:', error);
    throw error;
  }
};
