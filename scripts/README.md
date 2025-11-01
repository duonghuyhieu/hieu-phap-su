# 🤖 Automation Scripts Guide

This folder contains Node.js scripts for automated synchronization of Phasmophobia saves.

## 📁 Files

- `sync.js` - Main synchronization script
- `config.js` - Configuration file (Firebase credentials, paths)
- `package.json` - Node.js dependencies
- `sync-up.bat` - Windows batch wrapper for uploading
- `sync-down.bat` - Windows batch wrapper for downloading

## 🚀 Quick Start

### 1. Install Dependencies

```bash
npm install
```

This installs:
- `archiver` - For compressing save directories
- `extract-zip` - For extracting downloaded saves
- `node-fetch` - For Firestore API calls

### 2. Configure Firebase

Edit `config.js` and replace:

```javascript
export const FIREBASE_CONFIG = {
  projectId: "YOUR_PROJECT_ID",  // ← Your Firebase project ID
  apiKey: "YOUR_API_KEY"         // ← Your Firebase API key
};
```

### 3. Verify Save Path

The default save path is:
```
C:\Users\[YourUsername]\AppData\LocalLow\Kinetic Games\Phasmophobia
```

If your save is elsewhere, edit `SAVE_DIR` in `config.js`:

```javascript
export const SAVE_DIR = "C:\\Your\\Custom\\Path";
```

## 📤 Sync Up (Upload)

### Using Batch File (Recommended)

```bash
sync-up.bat "Save Name"
```

Example:
```bash
sync-up.bat "Level 50 All Items"
```

### Using Node Directly

```bash
node sync.js up "Save Name"
```

### What Happens

1. ✅ Checks if save directory exists
2. 📦 Compresses entire save directory to ZIP
3. 🔄 Converts ZIP to Base64
4. ☁️ Uploads to Firestore
5. 📋 Returns Save ID for sharing

### Output Example

```
🚀 Starting Sync Up...
📁 Save directory: C:\Users\...\Phasmophobia
📦 Compressing save directory...
✓ Compressed 1234567 bytes
🔄 Converting to Base64...
☁️  Uploading to Firestore...
✅ Sync Up completed successfully!
📋 Save ID: abc123xyz456
💾 Save Name: Level 50 All Items

🔗 Copy this ID to download the save later or share with others.
```

## 📥 Sync Down (Download)

### Using Batch File (Recommended)

```bash
sync-down.bat [SAVE_ID]
```

Example:
```bash
sync-down.bat abc123xyz456
```

### Using Node Directly

```bash
node sync.js down abc123xyz456
```

### What Happens

1. ☁️ Downloads save from Firestore
2. 💾 Backs up your current save (renamed with timestamp)
3. 🔄 Converts Base64 to ZIP
4. 📦 Extracts ZIP to save directory
5. ✅ Ready to play!

### Output Example

```
🚀 Starting Sync Down...
📋 Save ID: abc123xyz456
☁️  Downloading from Firestore...
💾 Save Name: Level 50 All Items
🔄 Converting from Base64...
💾 Backing up existing save to: C:\Users\...\Phasmophobia_backup_1234567890
📦 Extracting save files...
✓ Extracted to C:\Users\...\Phasmophobia
✅ Sync Down completed successfully!
📁 Save location: C:\Users\...\Phasmophobia

⚠️  Your previous save has been backed up.
🎮 You can now launch Phasmophobia and use the downloaded save!
```

## 🔧 Advanced Usage

### Custom Save Directory

Edit `config.js`:

```javascript
export const SAVE_DIR = join(
  'D:',
  'Games',
  'Phasmophobia',
  'Saves'
);
```

### Using npm Scripts

Add to your workflow:

```bash
npm run sync-up
npm run sync-down
```

### Programmatic Usage

Import and use in your own scripts:

```javascript
import { syncUp, syncDown } from './sync.js';

await syncUp('My Save Name');
await syncDown('save-id-here');
```

## 🐛 Troubleshooting

### Error: "Save directory not found"

**Problem**: Script can't find your Phasmophobia save folder

**Solutions**:
1. Verify the game is installed
2. Check the path in `config.js`
3. Make sure you've played the game at least once (to create save files)

**Find your save manually**:
1. Press `Win + R`
2. Type: `%APPDATA%\..\LocalLow\Kinetic Games\Phasmophobia`
3. Press Enter
4. Copy this path to `config.js`

### Error: "Firestore API error: 403"

**Problem**: Firebase credentials are incorrect or permissions denied

**Solutions**:
1. Check `config.js` has correct `projectId` and `apiKey`
2. Verify Anonymous Authentication is enabled in Firebase Console
3. Check Firestore security rules allow anonymous access

### Error: "Firestore API error: 404"

**Problem**: Save ID not found

**Solutions**:
1. Double-check the Save ID
2. Make sure you copied the entire ID
3. Verify the save exists in Firestore Console

### Error: "node: command not found"

**Problem**: Node.js is not installed or not in PATH

**Solutions**:
1. Install Node.js from https://nodejs.org
2. Restart your terminal/command prompt
3. Verify with: `node --version`

### Error: "Cannot find module 'archiver'"

**Problem**: Dependencies not installed

**Solution**:
```bash
npm install
```

### Error: "EPERM: operation not permitted"

**Problem**: File is in use or permission denied

**Solutions**:
1. Close Phasmophobia (game must not be running)
2. Run Command Prompt as Administrator
3. Check antivirus isn't blocking the script

### Warning: "Compressed file is large"

**Problem**: Save file exceeds Firestore's 1MB limit

**Solutions**:
1. Clean up unnecessary files in save directory
2. Use higher compression (modify `archiver` settings in `sync.js`)
3. Consider using Firebase Storage instead (requires code changes)

## 📊 Technical Details

### Compression

- **Library**: archiver
- **Format**: ZIP
- **Compression Level**: 9 (maximum)
- **Includes**: All files and subdirectories in save folder

### Encoding

- **Format**: Base64
- **Purpose**: Store binary data in Firestore (text-only database)
- **Size Impact**: ~33% larger than original ZIP

### API Endpoints

**Upload (POST)**:
```
https://firestore.googleapis.com/v1/projects/{projectId}/databases/(default)/documents/shared_saves?key={apiKey}
```

**Download (GET)**:
```
https://firestore.googleapis.com/v1/projects/{projectId}/databases/(default)/documents/shared_saves/{saveId}?key={apiKey}
```

### Backup Strategy

- Backups are created by renaming the existing save folder
- Format: `Phasmophobia_backup_{timestamp}`
- Location: Same parent directory as original save
- Automatic: No user intervention required

### File Structure

```
scripts/
├── sync.js           # Main script
├── config.js         # Configuration
├── package.json      # Dependencies
├── sync-up.bat       # Upload wrapper
├── sync-down.bat     # Download wrapper
├── temp/             # Temporary files (auto-created)
└── README.md         # This file
```

## 🔒 Security Considerations

### What Gets Uploaded

- All files in your Phasmophobia save directory
- This includes:
  - Player progress
  - Settings
  - Statistics
  - Any custom data

### What Doesn't Get Uploaded

- Your Steam ID (not stored in save files)
- Personal information
- Game installation files

### Privacy

- Saves are public and accessible to anyone
- No user authentication or tracking
- Anonymous uploads

### Recommendations

1. ✅ Review save contents before uploading
2. ✅ Don't include personal information in save names
3. ✅ Keep backups of important saves
4. ✅ Only download saves from trusted sources

## 💡 Tips & Best Practices

### Before Uploading

1. Close Phasmophobia completely
2. Choose a descriptive save name
3. Test the save works in your game first

### Before Downloading

1. Close Phasmophobia completely
2. Verify the Save ID is correct
3. Understand your current save will be backed up

### Save Naming

Good names:
- "Level 50 All Items Unlocked"
- "Nightmare Mode Completed"
- "Fresh Start - Tutorial Done"

Bad names:
- "save1"
- "test"
- "asdf"

### Sharing Saves

1. Upload your save
2. Copy the Save ID from output
3. Share the ID with others
4. They can download using `sync-down.bat [YOUR_SAVE_ID]`

## 🎯 Common Workflows

### Backup Your Save

```bash
sync-up.bat "My Backup - 2024-01-15"
```

### Try Someone's Save

```bash
sync-down.bat abc123xyz456
```

### Restore Your Backup

1. Find your backup folder: `Phasmophobia_backup_[timestamp]`
2. Delete current `Phasmophobia` folder
3. Rename backup folder to `Phasmophobia`

### Share Progress with Friends

1. Upload: `sync-up.bat "Our Co-op Progress"`
2. Share the Save ID with friends
3. Friends download: `sync-down.bat [SAVE_ID]`
4. Play together with same progress!

## 📞 Support

- Main documentation: [../README.md](../README.md)
- Firebase setup: [../FIREBASE_SETUP_GUIDE.md](../FIREBASE_SETUP_GUIDE.md)
- Issues: Check error messages and troubleshooting section above

---

Happy ghost hunting! 👻

