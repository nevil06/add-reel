# 🎉 AdReel Flutter App - Complete Setup

## ✅ What's Been Implemented

### 🔐 Authentication
- **Firebase Authentication** with Email/Password
- Beautiful **Login Screen** with gradient background
- **Sign Up Screen** with full name, email, and password validation
- **Auth State Management** - automatic login/logout handling
- **User Profile** display in settings

### 📹 Video Features
- **Vertical Video Feed** (TikTok-style)
- **Auto-Scroll Toggle** in settings (swipe to enable/disable)
- **Video Player** with play/pause controls
- **Progress Tracking** for each video
- **Sample Fallback Ads** (3 videos from Google's test library)

### 💰 Points & Wallet System
- **Firebase Firestore Integration** for user points
- **Points Service** synced with cloud database
- **Wallet Screen** showing balance and earnings
- **Points-to-INR Conversion** (5000 points = ₹1)
- **Minimum Withdrawal** threshold (10,000 points = ₹2)

### ⚙️ Settings & Features
- **Auto-Scroll Videos** toggle
- **Notifications** toggle
- **Data Saver** mode
- **User Profile** with Firebase data
- **Logout** functionality
- **Dark Mode** support (UI ready)

### 📱 Mobile-Ready
- **Android** support
- **iOS** support  
- **Windows** support (for testing)
- **Web** support (limited - no AdMob)

---

## 🚀 Quick Start Guide

### 1. Install Flutter Dependencies
```bash
cd c:\Users\nevil\OneDrive\Desktop\addreel\flutter_app
flutter pub get
```

### 2. Setup Firebase

#### Option A: Automatic (Recommended)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This will:
- Create a Firebase project (or use existing)
- Generate `firebase_options.dart`
- Configure Android & iOS automatically

#### Option B: Manual
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project: "addreel"
3. Enable **Email/Password** authentication
4. Create **Firestore Database** (test mode)
5. Download config files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`

### 3. Update Firebase Config in Code

After running `flutterfire configure`, update `lib/main.dart`:

**Replace:**
```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "YOUR_API_KEY",
    appId: "YOUR_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
  ),
);
```

**With:**
```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### 4. Run the App

#### On Android:
```bash
flutter run -d android
```

#### On iOS:
```bash
flutter run -d ios
```

#### On Windows (for testing):
```bash
flutter run -d windows
```

---

## 📂 Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                    # App entry + Firebase init + Auth wrapper
│   ├── screens/
│   │   ├── login_screen.dart        # Login UI
│   │   ├── signup_screen.dart       # Sign up UI
│   │   ├── feed_screen.dart         # Video feed (auto-scroll ready)
│   │   ├── wallet_screen.dart       # Points & earnings
│   │   ├── settings_screen.dart     # Settings + auto-scroll toggle
│   │   └── admin_screen.dart        # Admin dashboard
│   ├── services/
│   │   ├── auth_service.dart        # Firebase auth logic
│   │   ├── api_service.dart         # Fetch ads (with fallback)
│   │   ├── points_service.dart      # Points management
│   │   ├── admob_service.dart       # AdMob (mobile only)
│   │   └── analytics_service.dart   # Track views
│   ├── models/
│   │   ├── ad_model.dart           # Ad data structure
│   │   ├── company_model.dart      # Company data
│   │   └── user_points_model.dart  # Points data
│   └── widgets/
│       └── video_player_widget.dart # Video player component
├── android/                         # Android config
├── ios/                            # iOS config
├── FIREBASE_SETUP.md               # Detailed Firebase guide
└── pubspec.yaml                    # Dependencies
```

---

## 🎮 How to Use

### First Time Setup:
1. **Launch the app** → Login screen appears
2. **Tap "Sign Up"** → Create account with:
   - Full Name
   - Email
   - Password (min 6 characters)
3. **Login** with your credentials
4. **Main app loads** with 4 tabs:
   - 📹 **Feed** - Watch video ads
   - 💰 **Wallet** - View earnings
   - ⚙️ **Settings** - Configure app
   - 👨‍💼 **Admin** - Analytics dashboard

### Using Auto-Scroll:
1. Go to **Settings** tab
2. Toggle **"Auto-Scroll Videos"** ON
3. Return to **Feed** tab
4. Videos will auto-advance after completion

### Earning Points:
1. Watch videos in the **Feed**
2. Tap **"Earn Points"** button (when AdMob is configured)
3. Complete rewarded ads
4. Points sync to Firebase automatically
5. Check balance in **Wallet** tab

---

## 🔧 Configuration

### Adding Real Company Ads

Update `lib/services/api_service.dart` → `_getFallbackAds()`:

```dart
Ad(
  id: '4',
  companyId: 'company123',
  companyName: 'Your Company',
  videoUrl: 'https://your-video-url.mp4',
  title: 'Your Ad Title',
  description: 'Your ad description',
  ctaText: 'Shop Now',
  targetUrl: 'https://your-website.com',
  isActive: true,
  order: 4,
  createdAt: DateTime.now(),
),
```

### AdMob Integration (Mobile Only)

1. Get AdMob App IDs from [AdMob Console](https://apps.admob.com/)
2. Update `lib/config/app_config.dart`:
```dart
static const String androidRewardedAdUnitId = 'ca-app-pub-XXXXX/YYYYY';
static const String iosRewardedAdUnitId = 'ca-app-pub-XXXXX/ZZZZZ';
```
3. Update `android/app/src/main/AndroidManifest.xml`
4. Update `ios/Runner/Info.plist`

---

## 🗄️ Firebase Database Structure

### Users Collection:
```
users/{userId}
  - uid: string
  - email: string
  - name: string
  - points: number
  - totalEarned: number
  - createdAt: timestamp
```

### Firestore Security Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 📦 Build for Production

### Android APK:
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Google Play):
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS:
```bash
flutter build ios --release
```

---

## ✨ Features Summary

| Feature | Status | Notes |
|---------|--------|-------|
| Firebase Auth | ✅ | Email/Password |
| Firestore DB | ✅ | User data & points |
| Login/Signup | ✅ | Beautiful UI |
| Video Feed | ✅ | Vertical scroll |
| Auto-Scroll | ✅ | Toggle in settings |
| Points System | ✅ | Synced with Firebase |
| Wallet | ✅ | Shows balance |
| Settings | ✅ | Multiple options |
| Admin Dashboard | ✅ | Analytics |
| AdMob | ⚠️ | Mobile only (not web) |
| Dark Mode | 🔄 | UI ready, needs implementation |

---

## 🐛 Troubleshooting

### "Firebase not initialized"
```bash
flutterfire configure
```

### "Build failed"
```bash
flutter clean
flutter pub get
flutter run
```

### "No devices found"
- Connect Android device with USB debugging
- Or start Android emulator
- Or use `flutter run -d chrome` for web

---

## 📞 Next Steps

1. **Setup Firebase** using the guide above
2. **Test login/signup** flow
3. **Add real company video ads**
4. **Configure AdMob** for production
5. **Test auto-scroll** feature
6. **Build APK** and test on device
7. **Deploy to Play Store/App Store**

---

## 🎯 Key Files to Customize

- `lib/services/api_service.dart` - Add your video ads
- `lib/config/app_config.dart` - Points, AdMob IDs, API endpoints
- `lib/main.dart` - Firebase configuration
- `android/app/src/main/AndroidManifest.xml` - Android permissions
- `ios/Runner/Info.plist` - iOS permissions

---

**Your AdReel app is ready! 🚀**

Just setup Firebase and you're good to go!
