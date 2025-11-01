import { homedir } from 'os';
import { join } from 'path';

// Firebase configuration
// IMPORTANT: Replace these values with your actual Firebase project credentials
export const FIREBASE_CONFIG = {
 projectId: "phasmophobia-saves",
  apiKey: "AIzaSyC2rbVs2H-VoX5O0r2nvbAwCmSoAz_0GBU",
};

// Firestore REST API endpoints
export const FIRESTORE_BASE_URL = `https://firestore.googleapis.com/v1/projects/${FIREBASE_CONFIG.projectId}/databases/(default)/documents`;

// Collection name
export const COLLECTION_NAME = 'shared_saves';

// Local save directory path
// Default Phasmophobia save location
export const SAVE_DIR = join(
  homedir(),
  'AppData',
  'LocalLow',
  'Kinetic Games',
  'Phasmophobia'
);

// Temporary directory for compression/decompression
export const TEMP_DIR = join(process.cwd(), 'temp');

