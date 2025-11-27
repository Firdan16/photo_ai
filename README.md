# Photo AI

A Flutter application that generates AI images using Google Gemini API via Firebase Cloud Functions.

## 📱 Features

- **Text-to-Image Generation**: Generate images from text prompts
- **Image-to-Image Editing**: Upload a photo and transform it with AI
- **Gallery & Camera Support**: Pick images from gallery or capture with camera
- **Carousel Preview**: Swipe through generated images
- **Automatic Storage**: All images saved to Firebase Storage
- **Generation History**: Metadata stored in Firestore

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Flutter App                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  HomeScreen  │  │  AiService   │  │   StorageService     │  │
│  │   (UI)       │──│  (API calls) │  │   (Upload original)  │  │
│  └──────────────┘  └──────┬───────┘  └──────────────────────┘  │
└──────────────────────────│──────────────────────────────────────┘
                           │ HTTPS Callable
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Firebase Cloud Functions                       │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    generateImage                          │  │
│  │  - Validates request & auth                               │  │
│  │  - Calls Gemini API (API key stored securely)            │  │
│  │  - Uploads results to Storage                             │  │
│  │  - Saves metadata to Firestore                            │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
   │   Gemini    │  │  Firebase   │  │  Firebase   │
   │     API     │  │   Storage   │  │  Firestore  │
   └─────────────┘  └─────────────┘  └─────────────┘
```

### Project Structure

```
photo_ai/
├── lib/                          # Flutter source code
│   ├── main.dart                 # App entry point + Anonymous Auth
│   ├── core/
│   │   ├── services/
│   │   │   ├── ai_service.dart       # Cloud Function client
│   │   │   └── storage_service.dart  # Firebase Storage client
│   │   ├── theme/
│   │   │   └── app_theme.dart        # UI theme configuration
│   │   └── utils/
│   │       ├── error_helper.dart     # Error message handler
│   │       └── image_picker_helper.dart
│   └── features/
│       └── home/
│           ├── home_screen.dart      # Main UI screen
│           └── widgets/
│               ├── image_carousel.dart
│               └── story_thumbnail.dart
│
├── functions/                    # Cloud Functions source code
│   ├── src/
│   │   ├── index.ts              # Functions entry point
│   │   ├── ai/
│   │   │   └── generateImages.ts # Image generation function
│   │   └── services/
│   │       ├── gemini_service.ts # Gemini API wrapper
│   │       └── storage_service.ts# Server-side storage
│   ├── package.json
│   └── tsconfig.json
│
├── storage.rules                 # Firebase Storage security rules
├── firebase.json                 # Firebase configuration
└── pubspec.yaml                  # Flutter dependencies
```

## 🔒 Security Approach

### 1. API Key Protection
- **Gemini API key** is stored in Cloud Functions environment variables
- Never exposed to client-side code
- Set via Firebase CLI: `firebase functions:secrets:set GEMINI_API_KEY`

### 2. Authentication
- **Anonymous Authentication** enabled for easy onboarding
- All Cloud Functions require authenticated user (`request.auth.uid`)
- Users automatically signed in on app launch

### 3. Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can only access their own folder
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == userId;
    }
  }
}
```

### 4. Data Isolation
- Each user's data stored under `/users/{uid}/`
- Original images: `/users/{uid}/original/`
- Generated images: `/users/{uid}/generated/`
- Firestore: `/users/{uid}/generations/`

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.x or later)
- Node.js (18.x or later)
- Firebase CLI (`npm install -g firebase-tools`)
- Google Cloud account with billing enabled
- Gemini API key from [Google AI Studio](https://aistudio.google.com/)

### Step 1: Clone & Configure Firebase

```bash
# Clone the repository
git clone <repository-url>
cd photo_ai

# Login to Firebase
firebase login

# Create a new Firebase project or select existing
firebase projects:create photo-ai-yourname
# OR
firebase use --add
```

### Step 2: Enable Firebase Services

In [Firebase Console](https://console.firebase.google.com/):

1. **Authentication**
   - Go to Authentication → Sign-in method
   - Enable "Anonymous" provider

2. **Firestore Database**
   - Create a database named `photo` (or `(default)`)
   - Start in production mode

3. **Storage**
   - Enable Firebase Storage
   - Note the bucket name

### Step 3: Configure Flutter

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for Flutter
flutterfire configure

# Install Flutter dependencies
flutter pub get
```

### Step 4: Setup Cloud Functions

```bash
cd functions

# Install dependencies
npm install

# Set Gemini API key as secret
firebase functions:secrets:set GEMINI_API_KEY
# Enter your API key when prompted

# Deploy functions
firebase deploy --only functions
```

### Step 5: Deploy Storage Rules

```bash
# From project root
firebase deploy --only storage
```

### Step 6: Run the App

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## 📝 Environment Variables

### Cloud Functions
| Variable | Description |
|----------|-------------|
| `GEMINI_API_KEY` | Google Gemini API key (stored as secret) |

### Firebase Config
The `firebase.json` includes:
- Functions deployment configuration
- Storage rules path
- Firestore database settings

## 🔧 Development

### Running Functions Locally
```bash
cd functions
npm run build
firebase emulators:start --only functions
```

### Checking Logs
```bash
# Cloud Functions logs
firebase functions:log --only generateImage

# Specific time range
firebase functions:log --only generateImage --start 2024-01-01
```

## 📊 Firestore Data Model

### Users Collection
```
/users/{uid}
  - lastActive: timestamp
  - createdAt: timestamp

/users/{uid}/generations/{generationId}
  - prompt: string
  - originalUrl: string | null
  - inputImageUrl: string | null
  - hasInputImage: boolean
  - aspectRatio: string | null
  - generatedImages: string[]
  - count: number
  - status: "completed" | "failed"
  - createdAt: timestamp
```

## 📄 License

This project is licensed under the MIT License.
