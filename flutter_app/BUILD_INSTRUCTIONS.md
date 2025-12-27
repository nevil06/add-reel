# Building AdReel APK - Instructions

## 🚀 Quick Build Commands

### Standard Release APK (All Architectures)
```bash
flutter build apk --release
```

### ARM64 Only (Smaller file, most modern devices)
```bash
flutter build apk --release --target-platform android-arm64
```

### Split APKs (Smallest files, one per architecture)
```bash
flutter build apk --release --split-per-abi
```

---

## 📍 APK Location

After successful build, find your APK at:

```
flutter_app/build/app/outputs/flutter-apk/app-release.apk
```

Or for split APKs:
```
flutter_app/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
flutter_app/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
flutter_app/build/app/outputs/flutter-apk/app-x86_64-release.apk
```

---

## 🔧 Troubleshooting Build Issues

### Issue: Windows Directory Lock Error

**Error:**
```
Flutter failed to delete a directory at "windows\flutter\ephemeral\.plugin_symlinks"
```

**Solutions:**

1. **Close all programs** that might be using the directory:
   - Android Studio
   - VS Code
   - File Explorer windows
   - Any running Flutter processes

2. **Manually delete the directory:**
   ```bash
   rmdir /s /q windows\flutter\ephemeral
   ```

3. **Try building again:**
   ```bash
   flutter build apk --release
   ```

### Issue: Gradle Build Failed

**Solutions:**

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

2. **Check Java version:**
   ```bash
   java -version
   ```
   Should be Java 11 or higher

3. **Update Gradle (if needed):**
   Edit `android/gradle/wrapper/gradle-wrapper.properties`:
   ```properties
   distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-all.zip
   ```

### Issue: Out of Memory

**Solution:** Increase Gradle memory

Edit `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096M -XX:MaxPermSize=512m
```

---

## 📱 Installing APK on Device

### Via USB (ADB)
```bash
flutter install
```

Or manually:
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Via File Transfer
1. Copy APK to phone (USB, email, cloud storage)
2. Open APK on phone
3. Allow "Install from Unknown Sources" if prompted
4. Install

---

## ✅ Current Build Configuration

### AdMob Settings
- **App ID:** `ca-app-pub-7611642022143924~8359601006`
- **Rewarded Ad Unit:** `ca-app-pub-7611642022143924/2404405043`
- **Test Mode:** `true` (showing test ads)

### App Details
- **Package Name:** `com.example.addreel_flutter`
- **Version:** 1.0.0+1
- **Min SDK:** Android 21 (Lollipop)
- **Target SDK:** Android 34

---

## 🎯 Build Types

### Debug Build (Development)
```bash
flutter build apk --debug
```
- Larger file size
- Includes debug symbols
- Slower performance
- For testing only

### Profile Build (Performance Testing)
```bash
flutter build apk --profile
```
- Medium file size
- Performance profiling enabled
- For testing performance

### Release Build (Production)
```bash
flutter build apk --release
```
- Smallest file size
- Optimized performance
- No debug symbols
- For distribution

---

## 📦 App Bundle (For Play Store)

For Google Play Store submission, use App Bundle instead of APK:

```bash
flutter build appbundle --release
```

Location:
```
build/app/outputs/bundle/release/app-release.aab
```

---

## 🔐 Signing Configuration

### Current Status
Using debug signing (auto-generated)

### For Production
Create a keystore and configure signing:

1. **Generate keystore:**
   ```bash
   keytool -genkey -v -keystore ~/addreel-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias addreel
   ```

2. **Create `android/key.properties`:**
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=addreel
   storeFile=<path-to-keystore>
   ```

3. **Update `android/app/build.gradle`:**
   ```gradle
   signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   ```

---

## 📊 Build Time Estimates

- **First build:** 5-10 minutes
- **Subsequent builds:** 2-5 minutes
- **After clean:** 5-10 minutes

---

## 🎉 After Successful Build

1. **Locate APK:**
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

2. **Check file size:**
   - Should be ~50-80 MB

3. **Test on device:**
   ```bash
   flutter install
   ```

4. **Verify:**
   - App installs successfully
   - AdMob ads load
   - All features work
   - No crashes

---

## 📝 Build Checklist

Before building for production:

- [ ] Update version in `pubspec.yaml`
- [ ] Set `useTestAds = false` (if ready for production)
- [ ] Update API endpoint to production URL
- [ ] Test thoroughly on multiple devices
- [ ] Create signed keystore
- [ ] Configure signing in build.gradle
- [ ] Build app bundle (not APK) for Play Store
- [ ] Test the release build
- [ ] Prepare store listing

---

## 🚀 Quick Reference

**Most common command:**
```bash
flutter build apk --release
```

**APK location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

**Install on device:**
```bash
flutter install
```

That's it! 🎉
