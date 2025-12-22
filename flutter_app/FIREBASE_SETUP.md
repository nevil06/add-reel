# AdReel Flutter App - Firebase Setup Guide

## 🔥 Firebase Configuration

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `addreel` (or your preferred name)
4. Follow the setup wizard

### Step 2: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get Started"
3. Enable **Email/Password** sign-in method

### Step 3: Create Firestore Database

1. Go to **Firestore Database**
2. Click "Create database"
3. Choose **Start in test mode** (for development)
4. Select your preferred location

### Step 4: Add Firebase to Your App

#### For Android:
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your app
flutterfire configure
```

This will:
- Create `firebase_options.dart` file
- Update Android and iOS configurations automatically

#### Manual Setup (Alternative):

1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`
3. Update `android/build.gradle` and `android/app/build.gradle`

#### For iOS:
1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to `ios/Runner/` in Xcode

### Step 5: Update Firebase Options in Code

After running `flutterfire configure`, replace the Firebase initialization in `lib/main.dart`:

```dart
// Replace this:
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "YOUR_API_KEY",
    appId: "YOUR_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
  ),
);

// With this:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

And add this import:
```dart
import 'firebase_options.dart';
```

## 📱 Running the App

### On Android Device/Emulator:
```bash
flutter run -d android
```

### On iOS Simulator:
```bash
flutter run -d ios
```

### On Windows:
```bash
flutter run -d windows
```

## 🎯 Features

### ✅ Implemented
- 🔐 **Firebase Authentication** (Email/Password)
- 💾 **Firestore Database** for user data and points
- 📹 **Video Feed** with vertical scrolling
- 🎁 **Points System** synced with Firebase
- 💰 **Wallet** showing earnings
- ⚙️ **Settings** screen
- 👨‍💼 **Admin Dashboard**

### 🔄 Auto-Scroll Feature
- Swipe up/down to navigate between videos
- Videos auto-play when visible
- Smooth page transitions

## 🗄️ Firestore Database Structure

```
users/
  {userId}/
    - uid: string
    - email: string
    - name: string
    - points: number
    - totalEarned: number
    - createdAt: timestamp

ads/
  {adId}/
    - companyId: string
    - videoUrl: string
    - title: string
    - description: string
    - isActive: boolean
    - order: number
```

## 🔑 Test Credentials

For testing, you can create a new account or use:
- Email: `test@addreel.com`
- Password: `test123`

(Create this account through the sign-up screen)

## 🚀 Building for Production

### Android APK:
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store):
```bash
flutter build appbundle --release
```

### iOS:
```bash
flutter build ios --release
```

## 📝 Notes

- Replace test AdMob IDs with your production IDs before release
- Update Firestore security rules for production
- Enable Firebase Analytics for tracking
- Set up proper error logging (Firebase Crashlytics)

## 🔒 Security Rules (Firestore)

Update your Firestore rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Anyone can read ads
    match /ads/{adId} {
      allow read: if true;
      allow write: if false; // Only admins can write (set up admin role)
    }
  }
}
```

## 🆘 Troubleshooting

### Firebase not initializing:
- Make sure you ran `flutterfire configure`
- Check that `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) are in the correct locations

### Build errors:
```bash
flutter clean
flutter pub get
flutter run
```

### Authentication errors:
- Verify Email/Password is enabled in Firebase Console
- Check internet connection
- Ensure Firebase project is active

## 📞 Support

For issues, check:
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
