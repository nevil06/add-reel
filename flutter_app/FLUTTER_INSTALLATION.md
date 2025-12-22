# Flutter Installation Guide for Windows

## Step 1: Download Flutter SDK

1. Visit the Flutter website: https://docs.flutter.dev/get-started/install/windows
2. Click on "Download Flutter SDK" button
3. Download the latest stable release ZIP file (approximately 1.5 GB)

**Direct Download Link:** https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip

## Step 2: Extract Flutter SDK

1. Create a folder: `C:\src\flutter`
2. Extract the downloaded ZIP file to `C:\src\`
3. You should now have: `C:\src\flutter\bin\flutter.bat`

> **IMPORTANT:** Do NOT install Flutter in a directory like `C:\Program Files\` that requires elevated privileges.

## Step 3: Add Flutter to PATH

### Option A: Using System Settings (Recommended)

1. Open **Start Menu** → Search for "Environment Variables"
2. Click "Edit the system environment variables"
3. Click "Environment Variables..." button
4. Under "User variables", find "Path" and click "Edit"
5. Click "New" and add: `C:\src\flutter\bin`
6. Click "OK" on all dialogs
7. **Restart your terminal/PowerShell**

### Option B: Using PowerShell (Quick)

Run this command in PowerShell (as Administrator):

```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
```

Then restart your terminal.

## Step 4: Verify Installation

Open a **new** PowerShell window and run:

```bash
flutter --version
```

You should see output like:
```
Flutter 3.24.5 • channel stable • https://github.com/flutter/flutter.git
Framework • revision xyz123
Engine • revision abc456
Tools • Dart 3.5.4 • DevTools 2.37.3
```

## Step 5: Run Flutter Doctor

```bash
flutter doctor
```

This will check your environment and show what needs to be installed.

## Step 6: Install Android Studio (for Android development)

1. Download Android Studio: https://developer.android.com/studio
2. Run the installer
3. During installation, make sure these are checked:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device

4. After installation, open Android Studio:
   - Go to **Settings** → **Plugins**
   - Install "Flutter" plugin
   - Install "Dart" plugin

## Step 7: Accept Android Licenses

```bash
flutter doctor --android-licenses
```

Type `y` to accept all licenses.

## Step 8: Create Android Emulator

1. Open Android Studio
2. Click **More Actions** → **Virtual Device Manager**
3. Click **Create Device**
4. Select a device (e.g., Pixel 7)
5. Select a system image (e.g., Android 13)
6. Click **Finish**

## Step 9: Verify Setup

```bash
flutter doctor -v
```

You should see checkmarks (✓) for:
- Flutter
- Android toolchain
- Android Studio

## Step 10: Run Your AdReel App

```bash
cd C:\Users\nevil\OneDrive\Desktop\addreel\flutter_app
flutter pub get
flutter run
```

---

## Troubleshooting

### "flutter: command not found"
- Make sure you restarted your terminal after adding to PATH
- Verify PATH contains `C:\src\flutter\bin`
- Run: `$env:Path` in PowerShell to check

### "Android SDK not found"
- Run: `flutter doctor --android-licenses`
- Make sure Android Studio is installed
- Set ANDROID_HOME environment variable

### "No devices found"
- Start an Android emulator from Android Studio
- Or connect a physical Android device with USB debugging enabled

---

## Quick Commands Reference

```bash
# Check Flutter version
flutter --version

# Check environment setup
flutter doctor

# Get dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>

# Build APK
flutter build apk

# Clean build
flutter clean
```

---

## Next Steps After Installation

1. Restart your terminal/PowerShell
2. Navigate to the flutter_app directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter doctor` to verify everything is set up
5. Start an Android emulator
6. Run `flutter run` to launch the app

---

## Estimated Time

- Download: 10-20 minutes (depending on internet speed)
- Installation: 30-45 minutes (including Android Studio)
- Total: ~1 hour

---

## Need Help?

If you encounter any issues:
1. Run `flutter doctor -v` for detailed diagnostics
2. Check the official Flutter documentation: https://docs.flutter.dev/
3. Let me know the specific error message
