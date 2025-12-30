# GitHub Actions APK Build Guide

This project is configured to automatically build Android APKs using GitHub Actions.

## How It Works

Every time you push code to GitHub, the workflow automatically:
1. Sets up Flutter and Java
2. Downloads dependencies
3. Builds the APK
4. Uploads it as a downloadable artifact

## Getting Your APK

### Method 1: Automatic Build (After Push)

1. **Push your code to GitHub**:
   ```bash
   cd c:\Users\nevil\OneDrive\Desktop\addreel
   git add .
   git commit -m "Ready for APK build"
   git push origin main
   ```

2. **Go to GitHub Actions**:
   - Visit: https://github.com/nevil06/add-reel/actions
   - Click on the latest workflow run
   - Wait for it to complete (~5-10 minutes)

3. **Download APK**:
   - Scroll to "Artifacts" section
   - Click "addreel-debug-apk" to download
   - Extract the ZIP file to get `app-debug.apk`

### Method 2: Manual Trigger

1. Go to: https://github.com/nevil06/add-reel/actions
2. Click "Build Android APK" workflow
3. Click "Run workflow" button
4. Select branch (main)
5. Click "Run workflow"
6. Wait for completion and download from Artifacts

## Installing the APK

1. **Transfer to Android device**:
   - Email it to yourself
   - Use Google Drive/Dropbox
   - Connect via USB and copy

2. **Enable Unknown Sources**:
   - Settings → Security → Unknown Sources (enable)

3. **Install**:
   - Open the APK file on your device
   - Tap "Install"

## Troubleshooting

**Build Failed?**
- Check the workflow logs in GitHub Actions
- Ensure all dependencies are in `pubspec.yaml`
- Verify `build.gradle` has correct configuration

**Can't Download?**
- Artifacts expire after 30 days
- You must be logged into GitHub
- Re-run the workflow if expired

## Local Build (Requires Android Studio)

If you install Android Studio with Android SDK:

```bash
cd c:\Users\nevil\OneDrive\Desktop\addreel\flutter_app
flutter build apk --debug
```

APK location: `build\app\outputs\flutter-apk\app-debug.apk`
