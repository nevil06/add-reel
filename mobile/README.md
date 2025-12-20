# AdReel Mobile App

Instagram-style reels feed for video advertisements with Google AdMob integration and customizable points system.

## Features

- 📱 **Vertical Video Feed**: Instagram Reels-style interface for browsing video ads
- 💰 **Points System**: Earn points by watching rewarded ads
- 🎁 **AdMob Integration**: Google AdMob rewarded video ads
- 💳 **Wallet**: Track your points and INR equivalent
- ⚙️ **Customizable**: Adjustable points conversion rate and commission
- 📊 **Admin Dashboard**: Track analytics and manage configuration
- 🎨 **Modern UI**: Beautiful, responsive design with smooth animations

## Prerequisites

- Node.js 16+ installed
- Expo CLI (`npm install -g expo-cli`)
- Expo Go app on your iOS/Android device
- Google AdMob account (for production)

## Installation

1. Navigate to the mobile directory:
```bash
cd mobile
```

2. Install dependencies:
```bash
npm install
```

## Running the App

### Development Mode

Start the Expo development server:
```bash
npm start
```

This will open Expo DevTools in your browser. You can then:
- Scan the QR code with Expo Go (Android) or Camera app (iOS)
- Press `a` to open in Android emulator
- Press `i` to open in iOS simulator
- Press `w` to open in web browser

### Platform-Specific Commands

```bash
# Android
npm run android

# iOS
npm run ios

# Web
npm run web
```

## Configuration

### Points System

Edit `src/config/appConfig.ts` to customize:

```typescript
points: {
  pointsPerRewardedAd: 100,        // Points earned per ad
  pointsPerINR: 5000,              // Conversion rate (5000 points = ₹1)
  minimumWithdrawal: 10000,        // Minimum points to withdraw
}
```

### Commission Rate

```typescript
commission: {
  commissionRate: 0.3,  // 30% commission
}
```

### AdMob Configuration

**Important**: Replace test AdMob IDs with your actual IDs before production:

1. Create an AdMob account at https://admob.google.com
2. Create an app and rewarded ad units
3. Update `src/config/appConfig.ts`:

```typescript
admob: {
  iosRewardedAdUnitId: 'ca-app-pub-XXXXX/XXXXX',
  androidRewardedAdUnitId: 'ca-app-pub-XXXXX/XXXXX',
}
```

4. Update `app.json` with your AdMob App IDs:

```json
{
  "ios": {
    "infoPlist": {
      "GADApplicationIdentifier": "ca-app-pub-XXXXX~XXXXX"
    }
  },
  "android": {
    "config": {
      "googleMobileAdsAppId": "ca-app-pub-XXXXX~XXXXX"
    }
  }
}
```

### API Endpoint

Update the ads API endpoint in `src/config/appConfig.ts`:

```typescript
api: {
  adsEndpoint: 'https://your-website.vercel.app/api/ads',
  useFallbackData: true,
}
```

## Admin Access

Access the Admin screen via the bottom tab navigation.

**Default Password**: `admin123`

Change the password in `src/config/appConfig.ts`:

```typescript
export const ADMIN_CONFIG = {
  adminPassword: 'your-secure-password',
};
```

## Project Structure

```
mobile/
├── src/
│   ├── components/
│   │   └── VideoCard.tsx          # Video ad card component
│   ├── config/
│   │   └── appConfig.ts           # App configuration
│   ├── navigation/
│   │   └── AppNavigator.tsx       # Navigation setup
│   ├── screens/
│   │   ├── FeedScreen.tsx         # Main feed screen
│   │   ├── WalletScreen.tsx       # Points/wallet screen
│   │   ├── SettingsScreen.tsx     # Settings screen
│   │   └── AdminScreen.tsx        # Admin dashboard
│   ├── services/
│   │   ├── AdDataService.ts       # Ad data management
│   │   ├── AdMobService.ts        # AdMob integration
│   │   ├── PointsService.ts       # Points management
│   │   └── AnalyticsService.ts    # Analytics tracking
│   └── types/
│       └── index.ts               # TypeScript types
├── App.tsx                        # App entry point
├── app.json                       # Expo configuration
└── package.json                   # Dependencies
```

## Building for Production

### Android

```bash
expo build:android
```

### iOS

```bash
expo build:ios
```

For more details, see [Expo Build Documentation](https://docs.expo.dev/build/introduction/).

## Troubleshooting

### Videos not playing
- Ensure video URLs are accessible
- Check network connection
- Verify video format (MP4 recommended)

### AdMob ads not showing
- Verify AdMob IDs are correct
- Check AdMob account status
- Test ads may have limited availability

### Points not saving
- Check AsyncStorage permissions
- Clear app data and restart

## Notes

- The app uses AsyncStorage for local data persistence
- For production, consider implementing a backend service
- AdMob test IDs are included for development
- Sample video ads are provided for testing

## Support

For issues or questions, contact: support@addreel.com

## License

© 2025 AdReel. All rights reserved.
