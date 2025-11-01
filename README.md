# 👻 Phasmophobia Community Hub

Trung tâm cộng đồng Phasmophobia - Tải game và quản lý save game.

---

## 🚀 CÁCH SỬ DỤNG

### ⚡ NHANH NHẤT: Chạy GUI Online (Không cần download)

**Mở PowerShell và chạy lệnh sau:**
```powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO_NAME/main/quick-run.ps1 | iex
```

**Hoặc tạo shortcut 1-click:**
1. Tạo file `Launch-GUI.bat` với nội dung:
```batch
@echo off
powershell -Command "irm https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO_NAME/main/quick-run.ps1 | iex"
pause
```
2. Double-click để chạy GUI

📖 **Xem hướng dẫn chi tiết:** [ONLINE_GUI_GUIDE.md](ONLINE_GUI_GUIDE.md)

---

### 📦 Hoặc: Download và chạy local

#### 1. Khởi động Web Application
```bash
npm install
npm run dev
```
Mở browser tại `http://localhost:3000`

#### 2. Tải Game
- Vào tab "🎮 Tải Game"
- Download Part 1 và Part 2 từ Google Drive
- Làm theo hướng dẫn cài đặt

#### 3. Quản lý Save Game
- Vào tab "💾 Quản lý Save Game"
- Sử dụng GUI để upload/download saves
- Hoặc xem danh sách saves từ cộng đồng

---

## 🌟 Features

- **🎮 Game Download**: Direct links to download Phasmophobia game files
- **🎨 GUI Interface**: Beautiful Windows GUI for save management
- **🌐 Web Interface**: Browse and download saves from the community
- **☁️ Cloud Storage**: Saves stored in Firebase Firestore
- **🔄 Real-time Updates**: See new saves as they're uploaded
- **👥 Public Sharing**: No login required, completely anonymous
- **💾 Automatic Backups**: Your saves are backed up before downloading (via GUI)

## 📋 Table of Contents

- [System Architecture](#system-architecture)
- [Quick Start](#quick-start)
- [Firebase Setup](#firebase-setup)
- [Web Application](#web-application)
- [GUI Usage](#gui-usage)
- [Troubleshooting](#troubleshooting)

## 🏗️ System Architecture

The system consists of three main components:

### 1. Web Application
- **Technology**: React + Vite + Tailwind CSS
- **Features**: 2-tab interface (Game Download, Save Management)
- **Authentication**: Firebase Anonymous Auth
- **Purpose**: Central hub for downloading game and browsing saves

### 2. Database
- **Service**: Google Firestore
- **Access**: Public read/write
- **Storage**: Base64-encoded ZIP archives

### 3. GUI Application
- **Technology**: PowerShell + Windows Forms
- **Features**: Upload and download saves with GUI
- **Wrapper**: Batch file launcher (Launch-GUI.bat)
- **Purpose**: Easy save management without command line

## 🚀 Quick Start

### Prerequisites

- Node.js v18 or higher ([Download](https://nodejs.org))
- A Firebase project ([Create one](https://console.firebase.google.com))

### Installation

1. **Clone or download this repository**

2. **Install web app dependencies**:
   ```bash
   npm install
   ```

3. **Install script dependencies**:
   ```bash
   cd scripts
   npm install
   cd ..
   ```

4. **Configure Firebase** (see [Firebase Setup](#firebase-setup))

5. **Run the web app**:
   ```bash
   npm run dev
   ```

## 🔥 Firebase Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Enter project name (e.g., "phasmophobia-saves")
4. Disable Google Analytics (optional)
5. Click "Create project"

### Step 2: Enable Anonymous Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get started"
3. Go to **Sign-in method** tab
4. Enable **Anonymous** authentication
5. Click "Save"

### Step 3: Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Select **Start in production mode**
4. Choose a location (closest to your users)
5. Click "Enable"

### Step 4: Configure Security Rules

In Firestore Database, go to **Rules** tab and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /shared_saves/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Click "Publish"

### Step 5: Get Firebase Configuration

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to "Your apps"
3. Click the **Web** icon (`</>`)
4. Register app (nickname: "Phasmophobia Save Manager")
5. Copy the `firebaseConfig` object

### Step 6: Update Configuration Files

**For Web App** - Edit `src/firebase.js`:
```javascript
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.firebasestorage.app",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID",
  measurementId: "YOUR_MEASUREMENT_ID"
};
```

**For GUI Scripts** - Edit `scripts/config.js`:
```javascript
export const FIREBASE_CONFIG = {
  projectId: "YOUR_PROJECT_ID",
  apiKey: "YOUR_API_KEY"
};

export const SAVE_DIR = 'C:\\Users\\YourUsername\\AppData\\LocalLow\\Kinetic Games\\Phasmophobia';
```

**Note**: Current configuration is already set up. You only need to update if using your own Firebase project.

## 🌐 Web Application

### Running the Web App

```bash
npm run dev
```

The app will open at `http://localhost:3000`

### Building for Production

```bash
npm run build
```

Deploy the `dist` folder to any static hosting service (Firebase Hosting, Netlify, Vercel, etc.)

### Using the Web Interface

#### 🎮 Tải Game Tab
- **Quick Download**: One-click button to open both Google Drive links at once
- **Individual Downloads**: Separate links for Part 1 & Part 2
- **Installation Instructions**: Step-by-step guide
- **Tips and Warnings**: Important notes for installation

#### 💾 Quản lý Save Game Tab
- **GUI Download**: Download the GUI tool from GitHub
- **Step-by-step Guide**: How to set up and use the GUI on your local machine
- **Save Location**: Find your Phasmophobia save directory
- **Browse Saves**: View all saves uploaded by the community
- **Download**: Download saves as ZIP files or copy ID for GUI

## 🎨 GUI Usage

The easiest way to manage saves is using the GUI application.

### Launching the GUI

Simply double-click:
```
Launch-GUI.bat
```

### Features

- **Upload Save**: Enter a name and click Upload button
- **Download Save**: Enter Save ID and click Download button
- **Open Save Folder**: Quick access to Phasmophobia save directory
- **Help**: Built-in help and tips

### How to Upload

1. Launch GUI (`Launch-GUI.bat`)
2. Enter a descriptive name for your save
3. Click "🚀 Upload" button
4. Wait for completion
5. Copy the Save ID to share with others

### How to Download

1. Get a Save ID from:
   - Web interface (browse community saves)
   - Friends sharing their saves
2. Launch GUI (`Launch-GUI.bat`)
3. Enter the Save ID
4. Click "⬇️ Download" button
5. Your old save will be automatically backed up
6. Launch Phasmophobia and enjoy!

## ⚙️ Advanced: Command Line Scripts

For advanced users who want automation or scripting capabilities.

### Setup

1. Navigate to scripts folder:
   ```bash
   cd scripts
   npm install
   ```

2. Configure Firebase credentials in `config.js`

### Usage

#### Upload via Command Line

```bash
scripts\sync-up.bat "Save Name"
```

#### Download via Command Line

```bash
scripts\sync-down.bat [SAVE_ID]
```

Example:
```bash
scripts\sync-down.bat abc123xyz456
```

**What it does**:
1. Downloads save from Firestore
2. Backs up your current save
3. Extracts downloaded save to game directory
4. Ready to play!

### Save Location

Default location:
```
C:\Users\[YourUsername]\AppData\LocalLow\Kinetic Games\Phasmophobia
```

To change this, edit `SAVE_DIR` in `scripts/config.js`

**Quick access**: Press Win + R, paste this and hit Enter:
```
%APPDATA%\..\LocalLow\Kinetic Games\Phasmophobia
```

## 🔒 Security Rules

The Firestore security rules allow any authenticated user (including anonymous) to read and write saves. This is intentional for public sharing.

**Important Notes**:
- Anyone can upload/download saves
- No user data is stored
- Saves are public and accessible to all
- Consider file size limits (Firestore: 1MB per document)

## 📊 Data Structure

### Firestore Document Schema

Collection: `shared_saves`

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | User-defined save name |
| `content` | string | Base64-encoded ZIP file |
| `timestamp` | timestamp | Upload time |
| `uploaded_by` | string | Source ('Web UI' or 'Script') |

## 🐛 Troubleshooting

### Web App Issues

**Problem**: "Firebase not configured"
- **Solution**: Make sure you've updated `src/firebase.js` with your Firebase credentials

**Problem**: "Permission denied"
- **Solution**: Check Firestore security rules allow anonymous authentication

**Problem**: Saves not appearing
- **Solution**: Check browser console for errors, verify Firestore connection

**Problem**: Game download links not working
- **Solution**: Links are Google Drive links - make sure you're logged into Google and have access

### GUI Issues

**Problem**: GUI won't open
- **Solution**: Use `Launch-GUI.bat` instead of running the .ps1 file directly

**Problem**: Upload/Download not working
- **Solution**:
  1. Check Node.js is installed (`node --version`)
  2. Run `cd scripts && npm install`
  3. Verify Firebase config in `scripts/config.js`

**Problem**: Save directory not found
- **Solution**: Make sure you've played Phasmophobia at least once to create the save directory

### Script Issues

**Problem**: "Save directory not found"
- **Solution**: Verify the path in `scripts/config.js` matches your Phasmophobia installation

**Problem**: "Firestore API error"
- **Solution**: Check `scripts/config.js` has correct Firebase credentials

**Problem**: "node: command not found"
- **Solution**: Install Node.js from [nodejs.org](https://nodejs.org)

### General Issues

**Problem**: Upload fails with large saves
- **Solution**: Firestore has a 1MB document limit. Consider compressing more aggressively or splitting saves

**Problem**: Download overwrites my save
- **Solution**: Backups are created automatically. Look for folders named `Phasmophobia_backup_[timestamp]`

## 📝 File Size Considerations

Firestore has a **1MB limit per document**. If your save exceeds this:

1. The script will show an error
2. Consider cleaning up unnecessary files in your save directory
3. For very large saves, you may need to use Firebase Storage instead (requires code modification)

## 🤝 Contributing

This is a community project! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Share your saves

## ⚠️ Disclaimer

- **Backup your saves**: Always keep backups of your original saves
- **Use at your own risk**: Downloaded saves may not work with your game version
- **No warranty**: This tool is provided as-is
- **Not affiliated**: This project is not affiliated with Kinetic Games or Phasmophobia

## 📜 License

MIT License - Feel free to use, modify, and distribute

## 🎮 Happy Ghost Hunting!

Made with 💜 for the Phasmophobia community

