# AdReel Flutter App

Flutter mobile application for AdReel - Video Ads Platform with multi-company support.

## Features

- ✅ Instagram Reels-style vertical video feed
- ✅ Google AdMob rewarded video ads
- ✅ Points system with INR conversion (5,000 points = ₹1)
- ✅ Wallet with earnings tracking
- ✅ Multi-company ad support
- ✅ Admin analytics dashboard
- ✅ Offline caching
- ✅ Pull-to-refresh
- ✅ Modern Material Design 3 UI

## Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / Xcode for mobile development
- AdMob account (for production ads)

## Installation

### 1. Install Flutter

Follow the official Flutter installation guide:
https://docs.flutter.dev/get-started/install

### 2. Clone and Setup

```bash
cd flutter_app
flutter pub get
```

### 3. Configure API Endpoint

Edit `lib/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'https://your-vercel-url.vercel.app';
```

### 4. Configure AdMob (Production)

1. Create AdMob account at https://admob.google.com
2. Create rewarded ad units for Android and iOS
3. Update `lib/config/app_config.dart` with your Ad Unit IDs:

```dart
static const String androidRewardedAdUnitId = 'ca-app-pub-XXXXX/XXXXX';
static const String iosRewardedAdUnitId = 'ca-app-pub-XXXXX/XXXXX';
```

## Running the App

### Android

```bash
flutter run
```

### iOS

```bash
flutter run
```

### Web (for testing only)

```bash
flutter run -d chrome
```

## Building for Production

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode and archive.

## Project Structure

```
lib/
├── config/
│   └── app_config.dart          # App configuration
├── models/
│   ├── ad_model.dart            # Ad data model
│   ├── company_model.dart       # Company data model
│   └── user_points_model.dart   # Points & transactions model
├── screens/
│   ├── feed_screen.dart         # Main video feed
│   ├── wallet_screen.dart       # Points & earnings
│   ├── settings_screen.dart     # App settings
│   └── admin_screen.dart        # Analytics dashboard
├── services/
│   ├── api_service.dart         # API communication
│   ├── points_service.dart      # Points management
│   ├── admob_service.dart       # AdMob integration
│   └── analytics_service.dart   # Analytics tracking
├── widgets/
│   └── video_player_widget.dart # Video player component
└── main.dart                    # App entry point
```

## Configuration

### Points System

Edit `lib/config/app_config.dart`:

```dart
static const int pointsPerRewardedAd = 100;      // Points per ad watched
static const int pointsPerINR = 5000;            // 5000 points = ₹1
static const int minimumWithdrawal = 10000;      // Minimum to withdraw
```

### Commission Rate

```dart
static const double commissionRate = 0.3;  // 30% commission
```

### Admin Password

```dart
static const String adminPassword = 'admin123';  // Change this!
```

## Multi-Company Features

The app supports multiple companies managing their own ads:

- Each ad is associated with a company
- Company branding displayed on ads
- Company-specific analytics
- Unified feed showing ads from all companies

## Screens

### Feed Screen
- Vertical scrolling video feed (TikTok/Reels style)
- Auto-play videos
- Company branding overlay
- CTA buttons
- Pull-to-refresh

### Wallet Screen
- Points balance display
- INR conversion
- Earn points button (AdMob)
- Transaction history
- Withdrawal option

### Settings Screen
- Profile management
- Notifications toggle
- Dark mode toggle
- Data saver
- Clear cache
- Help & support
- Legal information

### Admin Screen
- Password protected (default: admin123)
- Total views analytics
- Earnings tracking
- Commission calculation
- Recent views list
- System information
- Reset analytics

## Dependencies

- `video_player` - Video playback
- `google_mobile_ads` - AdMob integration
- `http` - API calls
- `shared_preferences` - Local storage
- `provider` - State management
- `cached_network_image` - Image caching
- `url_launcher` - Open URLs
- `pull_to_refresh` - Pull to refresh
- `intl` - Date formatting

## API Integration

The app connects to the Next.js backend API:

- `GET /api/ads` - Fetch all ads
- `GET /api/ads?companyId=X` - Fetch company-specific ads
- `GET /api/companies` - Fetch all companies

## Testing

### Run Tests

```bash
flutter test
```

### Test AdMob Integration

The app uses test Ad Unit IDs by default. To test:

1. Run the app
2. Go to Wallet screen
3. Tap "Earn Points"
4. Watch the test ad
5. Verify points are added

## Troubleshooting

### Videos not playing
- Check network connection
- Verify video URLs are accessible
- Check console for errors

### AdMob ads not showing
- Verify Ad Unit IDs are correct
- Check AdMob account status
- Test ads may take time to load

### API connection failed
- Verify API endpoint URL in `app_config.dart`
- Check network connectivity
- Verify backend is running

### Build errors
- Run `flutter clean`
- Run `flutter pub get`
- Check Flutter version compatibility

## Production Checklist

- [ ] Update API endpoint to production URL
- [ ] Replace AdMob test IDs with production IDs
- [ ] Change admin password
- [ ] Configure app icons
- [ ] Configure splash screen
- [ ] Test on multiple devices
- [ ] Enable ProGuard (Android)
- [ ] Configure signing (Android/iOS)
- [ ] Test in-app purchases (if applicable)
- [ ] Submit to App Store / Play Store

## License

© 2025 AdReel. All rights reserved.

## Support

For issues or questions, please contact support@addreel.com
