# Building AdReel for Google Play Store

This guide walks you through building a production-ready release of AdReel for the Google Play Store.

## Prerequisites

- ✅ Flutter SDK installed
- ✅ Android Studio with Android SDK
- ✅ Java JDK 8 or higher

---

## Step 1: Configure Firebase

Before building, you **must** configure Firebase with your own project:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (follow prompts)
flutterfire configure
```

This will:
- Create `firebase_options.dart` with your Firebase config
- Update Android and iOS configurations
- Link your app to your Firebase project

---

## Step 2: Create Signing Keystore

A keystore is required to sign your app. **Keep this file safe** - you cannot update your app without it!

### Generate Keystore

```bash
keytool -genkey -v -keystore c:\Users\nevil\OneDrive\Desktop\addreel\flutter_app\android\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias addreel-key
```

You'll be prompted for:
- **Keystore password**: Choose a strong password (remember this!)
- **Key password**: Can be same as keystore password
- **Name, Organization, etc.**: Fill in your details

### Configure key.properties

Copy the template and fill in your passwords:

```bash
cd c:\Users\nevil\OneDrive\Desktop\addreel\flutter_app\android
copy key.properties.template key.properties
```

Edit `key.properties`:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=addreel-key
storeFile=../upload-keystore.jks
```

> [!CAUTION]
> **Never commit `key.properties` or `upload-keystore.jks` to Git!** They contain sensitive credentials.

---

## Step 3: Update Configuration

### Update API URL

Edit `lib/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'https://your-production-url.vercel.app';
```

### Verify AdMob Settings

Ensure production ads are enabled in `lib/config/app_config.dart`:
```dart
static const bool useTestAds = false; // Must be false for production!
```

---

## Step 4: Build Release

### Option A: Build APK (for testing)

```bash
cd c:\Users\nevil\OneDrive\Desktop\addreel\flutter_app
flutter build apk --release
```

APK location: `build\app\outputs\flutter-apk\app-release.apk`

### Option B: Build App Bundle (for Play Store) ⭐ **RECOMMENDED**

```bash
cd c:\Users\nevil\OneDrive\Desktop\addreel\flutter_app
flutter build appbundle --release
```

AAB location: `build\app\outputs\bundle\release\app-release.aab`

> [!TIP]
> App Bundles (AAB) are smaller and optimized for different device configurations. Google Play requires AAB for new apps.

---

## Step 5: Test Release Build

Install the APK on a physical device:

```bash
adb install build\app\outputs\flutter-apk\app-release.apk
```

**Test checklist:**
- [ ] App launches without errors
- [ ] Login/signup works (Firebase must be configured)
- [ ] Ads load and display
- [ ] Points are awarded after watching ads
- [ ] Wallet shows correct balance
- [ ] No debug features visible

---

## Step 6: Prepare Play Store Listing

### Required Assets

1. **App Icon**: 512x512 PNG (already generated in artifacts)
2. **Feature Graphic**: 1024x500 PNG
3. **Screenshots**: At least 2 screenshots (phone + tablet)
4. **Privacy Policy URL**: Host `PRIVACY_POLICY.md` online

### Store Listing Information

**Title**: AdReel - Watch Ads, Earn Money

**Short Description** (80 chars):
```
Watch video ads and earn real money. Convert points to INR instantly!
```

**Full Description**:
```
💰 Earn Money by Watching Ads!

AdReel is the easiest way to earn real money by watching video advertisements. Simply scroll through ads, watch them, and collect points that convert to Indian Rupees (INR).

✨ Features:
• Instagram Reels-style vertical ad feed
• Earn 5 points per ad watched
• 5,000 points = ₹1 conversion rate
• Withdraw earnings directly to your account
• Safe and secure with Firebase authentication
• Multiple ad networks for variety

🎯 How It Works:
1. Download and sign up
2. Watch video ads in the feed
3. Earn points automatically
4. Convert points to INR
5. Withdraw your earnings!

📊 Transparent System:
• Clear points tracking
• Real-time wallet balance
• Transaction history
• No hidden fees

Start earning today with AdReel!
```

**Category**: Finance

**Content Rating**: Everyone (complete questionnaire)

---

## Step 7: Submit to Play Store

1. **Create Developer Account**: https://play.google.com/console ($25 one-time fee)

2. **Create New App**:
   - App name: AdReel
   - Default language: English
   - App or Game: App
   - Free or Paid: Free

3. **Upload App Bundle**:
   - Go to "Production" → "Create new release"
   - Upload `app-release.aab`
   - Add release notes

4. **Complete Store Listing**:
   - Add all required assets
   - Fill in descriptions
   - Add privacy policy URL
   - Complete content rating questionnaire

5. **Set Up Pricing & Distribution**:
   - Select countries
   - Confirm content guidelines
   - Submit for review

---

## Troubleshooting

### Build Fails

**Error**: "Keystore not found"
- Ensure `key.properties` exists and paths are correct

**Error**: "Firebase not configured"
- Run `flutterfire configure` first

### App Crashes on Launch

- Check Firebase configuration
- Verify all dependencies are up to date: `flutter pub get`
- Check logcat for errors: `adb logcat`

### Ads Not Showing

- Ensure `useTestAds = false` in production
- Verify AdMob app is approved (can take 24-48 hours)
- Check internet connection

---

## Important Notes

> [!WARNING]
> **Version Updates**: When releasing updates, increment version in `pubspec.yaml`:
> ```yaml
> version: 1.0.1+2  # Format: major.minor.patch+buildNumber
> ```

> [!IMPORTANT]
> **Keystore Backup**: Store your keystore and passwords in a secure location (password manager, encrypted drive). Losing them means you cannot update your app!

---

## Next Steps After Approval

1. **Monitor Analytics**: Check Firebase Analytics for user behavior
2. **Track Revenue**: Monitor AdMob earnings
3. **Gather Feedback**: Read user reviews and ratings
4. **Plan Updates**: Add features based on user requests

---

**Need Help?**
- Flutter Docs: https://docs.flutter.dev/deployment/android
- Play Console Help: https://support.google.com/googleplay/android-developer
