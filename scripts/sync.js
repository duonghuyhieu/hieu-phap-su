#!/usr/bin/env node

import fs from 'fs';
import path from 'path';
import archiver from 'archiver';
import extract from 'extract-zip';
import fetch from 'node-fetch';
import { FIREBASE_CONFIG, FIRESTORE_BASE_URL, COLLECTION_NAME, SAVE_DIR, TEMP_DIR } from './config.js';

// Ensure temp directory exists
if (!fs.existsSync(TEMP_DIR)) {
  fs.mkdirSync(TEMP_DIR, { recursive: true });
}

/**
 * Compress a directory to a ZIP file
 * @param {string} sourceDir - Directory to compress
 * @param {string} outputPath - Output ZIP file path
 * @returns {Promise<void>}
 */
async function compressDirectory(sourceDir, outputPath) {
  return new Promise((resolve, reject) => {
    const output = fs.createWriteStream(outputPath);
    const archive = archiver('zip', { zlib: { level: 9 } });

    output.on('close', () => {
      console.log(`✓ Compressed ${archive.pointer()} bytes`);
      resolve();
    });

    archive.on('error', (err) => reject(err));

    archive.pipe(output);
    archive.directory(sourceDir, false);
    archive.finalize();
  });
}

/**
 * Extract a ZIP file to a directory
 * @param {string} zipPath - ZIP file path
 * @param {string} targetDir - Target directory
 * @returns {Promise<void>}
 */
async function extractZip(zipPath, targetDir) {
  await extract(zipPath, { dir: path.resolve(targetDir) });
  console.log(`✓ Extracted to ${targetDir}`);
}

/**
 * Convert file to Base64
 * @param {string} filePath - File path
 * @returns {string} Base64 encoded string
 */
function fileToBase64(filePath) {
  const fileBuffer = fs.readFileSync(filePath);
  return fileBuffer.toString('base64');
}

/**
 * Convert Base64 to file
 * @param {string} base64String - Base64 encoded string
 * @param {string} outputPath - Output file path
 */
function base64ToFile(base64String, outputPath) {
  const buffer = Buffer.from(base64String, 'base64');
  fs.writeFileSync(outputPath, buffer);
}

/**
 * Upload save to Firestore
 * @param {string} saveName - Name for the save
 * @returns {Promise<void>}
 */
async function syncUp(saveName) {
  try {
    console.log('🚀 Starting Sync Up...');
    
    // Check if save directory exists
    if (!fs.existsSync(SAVE_DIR)) {
      throw new Error(`Save directory not found: ${SAVE_DIR}`);
    }

    console.log(`📁 Save directory: ${SAVE_DIR}`);

    // Compress the save directory
    const zipPath = path.join(TEMP_DIR, 'save.zip');
    console.log('📦 Compressing save directory...');
    await compressDirectory(SAVE_DIR, zipPath);

    // Convert to Base64
    console.log('🔄 Converting to Base64...');
    const base64Content = fileToBase64(zipPath);

    // Prepare Firestore document
    const document = {
      fields: {
        name: { stringValue: saveName },
        content: { stringValue: base64Content },
        timestamp: { timestampValue: new Date().toISOString() },
        uploaded_by: { stringValue: 'Script' }
      }
    };

    // Upload to Firestore
    console.log('☁️  Uploading to Firestore...');
    const url = `${FIRESTORE_BASE_URL}/${COLLECTION_NAME}?key=${FIREBASE_CONFIG.apiKey}`;
    
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(document)
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Firestore API error: ${response.status} - ${errorText}`);
    }

    const result = await response.json();
    const docId = result.name.split('/').pop();

    // Clean up
    fs.unlinkSync(zipPath);

    console.log('✅ Sync Up completed successfully!');
    console.log(`📋 Save ID: ${docId}`);
    console.log(`💾 Save Name: ${saveName}`);
    console.log('\n🔗 Copy this ID to download the save later or share with others.');

  } catch (error) {
    console.error('❌ Error during Sync Up:', error.message);
    process.exit(1);
  }
}

/**
 * Download save from Firestore
 * @param {string} saveId - Document ID to download
 * @returns {Promise<void>}
 */
async function syncDown(saveId) {
  try {
    console.log('🚀 Starting Sync Down...');
    console.log(`📋 Save ID: ${saveId}`);

    // Fetch document from Firestore
    console.log('☁️  Downloading from Firestore...');
    const url = `${FIRESTORE_BASE_URL}/${COLLECTION_NAME}/${saveId}?key=${FIREBASE_CONFIG.apiKey}`;
    
    const response = await fetch(url);

    if (!response.ok) {
      if (response.status === 404) {
        throw new Error('Save not found. Please check the ID and try again.');
      }
      const errorText = await response.text();
      throw new Error(`Firestore API error: ${response.status} - ${errorText}`);
    }

    const document = await response.json();

    // Extract data
    const saveName = document.fields.name.stringValue;
    const base64Content = document.fields.content.stringValue;

    console.log(`💾 Save Name: ${saveName}`);

    // Convert Base64 to file
    console.log('🔄 Converting from Base64...');
    const zipPath = path.join(TEMP_DIR, 'downloaded_save.zip');
    base64ToFile(base64Content, zipPath);

    // Backup existing save
    if (fs.existsSync(SAVE_DIR)) {
      const backupDir = `${SAVE_DIR}_backup_${Date.now()}`;
      console.log(`💾 Backing up existing save to: ${backupDir}`);
      fs.renameSync(SAVE_DIR, backupDir);
    }

    // Create save directory
    if (!fs.existsSync(SAVE_DIR)) {
      fs.mkdirSync(SAVE_DIR, { recursive: true });
    }

    // Extract to save directory
    console.log('📦 Extracting save files...');
    await extractZip(zipPath, SAVE_DIR);

    // Clean up
    fs.unlinkSync(zipPath);

    console.log('✅ Sync Down completed successfully!');
    console.log(`📁 Save location: ${SAVE_DIR}`);
    console.log('\n⚠️  Your previous save has been backed up.');
    console.log('🎮 You can now launch Phasmophobia and use the downloaded save!');

  } catch (error) {
    console.error('❌ Error during Sync Down:', error.message);
    process.exit(1);
  }
}

/**
 * Display usage information
 */
function showUsage() {
  console.log(`
╔════════════════════════════════════════════════════════════╗
║     Phasmophobia Save Sync - Automation Script            ║
╚════════════════════════════════════════════════════════════╝

Usage:
  node sync.js up <save-name>     Upload your local save
  node sync.js down <save-id>     Download a save from cloud

Examples:
  node sync.js up "Level 50 All Items"
  node sync.js down "abc123xyz456"

Notes:
  - Make sure to configure your Firebase credentials in config.js
  - Your save directory: ${SAVE_DIR}
  - Backups are created automatically before downloading
  `);
}

// Main execution
const args = process.argv.slice(2);
const command = args[0];
const param = args[1];

if (!command || !param) {
  showUsage();
  process.exit(1);
}

switch (command.toLowerCase()) {
  case 'up':
  case 'upload':
    syncUp(param);
    break;
  case 'down':
  case 'download':
    syncDown(param);
    break;
  default:
    console.error(`❌ Unknown command: ${command}`);
    showUsage();
    process.exit(1);
}

