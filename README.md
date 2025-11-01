# 👻 Phasmophobia Save Manager

A simple, text-based save game management system for Phasmophobia using Firebase Firestore.

## 🎯 Features

- **Create Save**: Upload text files or type content directly
- **List Saves**: View all saved games with details
- **Download Save**: Download saves as `.txt` files
- **Edit Save**: Update save name or content
- **Delete Save**: Remove unwanted saves
- **Simple & Clean**: No complex compression, just plain text files
- **Firebase Powered**: Cloud storage with real-time updates

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Firebase Setup](#firebase-setup)
- [Usage](#usage)
- [Development](#development)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

## 🚀 Quick Start

### Prerequisites

- Node.js (v16 or higher) - [Download](https://nodejs.org)
- npm or yarn
- Firebase account - [Create one](https://console.firebase.google.com)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/duonghuyhieu/hieu-phap-su.git
cd hieu-phap-su
```

2. Install dependencies:
```bash
npm install
```

3. Configure Firebase (see [Firebase Setup](#firebase-setup))

4. Start the development server:
```bash
npm run dev
```

5. Open your browser and navigate to `http://localhost:3000`

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
    match /saves/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Click "Publish"

⚠️ **Note**: These rules allow any authenticated user (including anonymous) to read/write. For production, implement proper authentication.

### Step 5: Get Firebase Configuration

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to "Your apps"
3. Click the **Web** icon (`</>`)
4. Register app (nickname: "Phasmophobia Save Manager")
5. Copy the `firebaseConfig` object

### Step 6: Update Configuration

Edit `src/firebase.js` and replace the `firebaseConfig` object with your credentials:

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

## 📝 Usage

### Creating a Save

1. Click on the **"Create Save"** tab
2. Enter a name for your save
3. Either:
   - Upload a `.txt` file, OR
   - Type/paste content directly into the text area
4. Click **"Create Save"**

### Listing Saves

1. Click on the **"List Saves"** tab
2. View all saves with:
   - Save name
   - Save ID
   - Creation and update timestamps
   - Content preview (click "View Content")
3. Actions available:
   - **Copy ID**: Copy save ID to clipboard
   - **Edit**: Update save name or content
   - **Delete**: Remove the save

### Downloading a Save

1. Click on the **"Download Save"** tab
2. Enter the Save ID (copy from List Saves tab)
3. Click **"Download as .txt"**
4. The save will be downloaded as a text file

## 🛠️ Development

### Project Structure

```
hieu-phap-su/
├── src/
│   ├── App.jsx          # Main React component
│   ├── firebase.js      # Firebase configuration and CRUD functions
│   ├── main.jsx         # React entry point
│   └── index.css        # Tailwind CSS styles
├── public/              # Static assets
├── package.json         # Dependencies
└── vite.config.js       # Vite configuration
```

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build

### Firebase Functions

The following functions are available in `src/firebase.js`:

- `createSave(saveName, saveContent)` - Create a new save
- `getSave(saveId)` - Get a save by ID
- `getAllSaves()` - Get all saves
- `updateSave(saveId, saveName, saveContent)` - Update a save
- `deleteSave(saveId)` - Delete a save

## 🎨 Tech Stack

- **Frontend**: React + Vite
- **Styling**: Tailwind CSS
- **Database**: Firebase Firestore
- **Authentication**: Firebase Anonymous Auth

## 📦 Deployment

### Deploy to Firebase Hosting

1. Install Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Login to Firebase:
```bash
firebase login
```

3. Initialize Firebase:
```bash
firebase init
```

4. Build the project:
```bash
npm run build
```

5. Deploy:
```bash
firebase deploy
```

### Deploy to Vercel

1. Install Vercel CLI:
```bash
npm install -g vercel
```

2. Deploy:
```bash
vercel
```

## 📊 Data Structure

### Firestore Document Schema

Collection: `saves`

| Field | Type | Description |
|-------|------|-------------|
| `saveName` | string | User-provided name for the save |
| `saveContent` | string | The text content of the save file |
| `createdAt` | timestamp | Creation timestamp |
| `updatedAt` | timestamp | Last update timestamp |

## 🐛 Troubleshooting

### Common Issues

**Problem**: "Firebase not configured"
- **Solution**: Update `src/firebase.js` with your Firebase credentials

**Problem**: "Permission denied"
- **Solution**: Check Firestore security rules allow anonymous authentication

**Problem**: Saves not appearing
- **Solution**: Check browser console for errors, verify Firestore connection

**Problem**: Can't create save
- **Solution**: Make sure both name and content are provided

**Problem**: Download not working
- **Solution**: Verify the Save ID is correct (copy from List Saves tab)

## 🔒 Security Notes

- The current implementation uses Firebase Anonymous Authentication
- For production use, implement proper user authentication
- Update Firestore security rules to restrict access
- Never commit Firebase credentials to version control
- Use environment variables for sensitive configuration

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Built for the Phasmophobia community
- Powered by Firebase and React

## 📞 Support

If you encounter any issues or have questions, please open an issue on GitHub.

---

Made with 💜 for the Phasmophobia community
