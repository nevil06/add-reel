# AdReel - Video Ads Platform

Complete solution for an Instagram-style reels feed mobile app for video advertisements with admin management website and **multi-company support**.

## 📦 Project Structure

```
addreel/
├── flutter_app/         # Flutter mobile app (replaces Expo)
│   ├── lib/
│   │   ├── config/      # App configuration
│   │   ├── models/      # Data models (Ad, Company, Points)
│   │   ├── screens/     # App screens (Feed, Wallet, Settings, Admin)
│   │   ├── services/    # Business logic (API, Points, AdMob, Analytics)
│   │   └── widgets/     # Reusable widgets
│   ├── android/         # Android configuration
│   ├── ios/             # iOS configuration
│   ├── pubspec.yaml     # Dependencies
│   └── README.md        # Flutter app documentation
│
├── mobile/              # [DEPRECATED] Old Expo app
│
└── website/             # Next.js admin website
    ├── app/
    │   ├── admin/       # Admin dashboard
    │   ├── api/         # API routes (ads, companies)
    │   └── page.tsx     # Landing page
    ├── lib/             # Utilities & schemas
    ├── public/          # Static files & data storage
    └── package.json
```

## 🚀 Quick Start

### Flutter Mobile App

```bash
cd flutter_app
flutter pub get
flutter run
```

See [flutter_app/README.md](flutter_app/README.md) for detailed instructions.

### Website

```bash
cd website
npm install
npm run dev
```

Visit http://localhost:3000 for the landing page and http://localhost:3000/admin for the admin dashboard.

## ✨ Features

### Mobile App (Flutter)
- ✅ Instagram Reels-style vertical video feed
- ✅ Google AdMob rewarded video ads integration
- ✅ Customizable points system (default: 5,000 points = ₹1)
- ✅ Points wallet with INR conversion
- ✅ Commission tracking for app owner
- ✅ Admin dashboard (password-protected)
- ✅ Settings and user management
- ✅ Offline support with local caching
- ✅ Pull-to-refresh for new ads
- ✅ **Multi-company ad support**
- ✅ **Company branding on ads**
- ✅ Material Design 3 UI

### Website
- ✅ Modern, responsive landing page
- ✅ Admin dashboard for ad management
- ✅ Upload, edit, delete video ads
- ✅ Activate/deactivate ads
- ✅ **Company management system**
- ✅ **Company authentication**
- ✅ **Per-company analytics**
- ✅ RESTful API for mobile app integration
- ✅ Vercel deployment ready
- ✅ SEO optimized

## 🎯 How It Works

### For Users (Mobile App)
1. **Download the app** from App Store or Play Store
2. **Browse video ads** in a reels-style feed
3. **Watch rewarded ads** by tapping "Earn Points"
4. **Collect points** that convert to real money
5. **Withdraw earnings** once minimum threshold is reached

### For Companies
1. **Create company account** via admin
2. **Upload video ads** with branding
3. **Set commission rates** per company
4. **Track analytics** for your ads
5. **Manage ad queue** - activate, deactivate, reorder

### For You (App Owner)
1. **Deploy website** to Vercel
2. **Manage companies** via admin dashboard
3. **Track analytics** - views, earnings, commission
4. **Configure settings** - points rate, commission, minimums

## 🆕 Multi-Company Features

### Company Management
- Create and manage multiple advertising companies
- Each company has unique branding (logo, colors)
- Custom commission rates per company
- Active/inactive status control

### Company-Specific Ads
- All ads are associated with a company
- Company branding displayed on video feed
- Filter ads by company via API
- Company-wise analytics tracking

### Unified User Experience
- Users see ads from all companies in one feed
- Seamless viewing experience
- Company branding maintains identity

## ⚙️ Configuration

### Points System

Edit `flutter_app/lib/config/app_config.dart`:

```dart
static const int pointsPerRewardedAd = 100;      // Points per ad watched
static const int pointsPerINR = 5000;            // 5000 points = ₹1
static const int minimumWithdrawal = 10000;      // Minimum to withdraw
```

### Commission Rate

```dart
static const double commissionRate = 0.3;  // 30% commission
```

### AdMob Setup

1. Create AdMob account at https://admob.google.com
2. Create rewarded ad units for iOS and Android
3. Update `flutter_app/lib/config/app_config.dart` with your Ad Unit IDs
4. Update Android and iOS manifest files

### API Integration

After deploying website to Vercel:

1. Copy your Vercel URL
2. Update `flutter_app/lib/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'https://your-site.vercel.app';
```

## 📱 Mobile App Screens

- **Feed**: Vertical scrolling video ads with auto-play and company branding
- **Wallet**: Points balance, INR value, earnings history, earn/withdraw
- **Settings**: Account settings, notifications, dark mode, support, legal
- **Admin**: Analytics dashboard (password: admin123)

## 🌐 Website Pages

- **/** - Landing page with hero, features, download CTAs
- **/admin** - Admin dashboard for ad and company management

## 🔌 API Endpoints

### Ads
- `GET /api/ads` - Fetch all ads
- `GET /api/ads?companyId=X` - Fetch company-specific ads
- `POST /api/ads` - Create new ad
- `PUT /api/ads` - Update ad
- `DELETE /api/ads?id={id}` - Delete ad

### Companies
- `GET /api/companies` - Fetch all companies
- `POST /api/companies` - Create new company
- `PUT /api/companies` - Update company
- `DELETE /api/companies?id={id}` - Delete company
- `POST /api/companies/auth` - Company login

## 🚢 Deployment

### Website (Vercel)

```bash
cd website
vercel
```

Or use the Vercel dashboard to import from Git.

### Mobile App (Flutter)

#### Android
```bash
cd flutter_app
flutter build appbundle --release
```

#### iOS
```bash
cd flutter_app
flutter build ios --release
```

Then open in Xcode and archive.

See [Flutter deployment docs](https://docs.flutter.dev/deployment) for detailed instructions.

## 🔐 Security Notes

- Change admin password in `flutter_app/lib/config/app_config.dart`
- Add authentication to website admin dashboard for production
- Use environment variables for sensitive data
- Implement rate limiting on API endpoints
- Use HTTPS for all communications

## 📝 Production Checklist

### Mobile App
- [ ] Update API endpoint to production URL
- [ ] Replace AdMob test IDs with production IDs
- [ ] Change admin password
- [ ] Configure app icons and splash screens
- [ ] Test on multiple devices (Android & iOS)
- [ ] Configure signing certificates
- [ ] Submit to App Store and Play Store

### Website
- [ ] Deploy to Vercel
- [ ] Add authentication to admin dashboard
- [ ] Set up database (replace JSON file storage)
- [ ] Configure custom domain
- [ ] Add SSL certificate
- [ ] Set up monitoring and alerts
- [ ] Implement backup strategy
- [ ] Add rate limiting

## 💡 Technology Stack

**Mobile App:**
- Flutter 3.0+
- Dart 3.0+
- Provider (state management)
- Google Mobile Ads
- Video Player
- HTTP & SharedPreferences

**Website:**
- Next.js 15
- React 19
- TypeScript
- Tailwind CSS

## 📚 Documentation

- [Flutter App README](flutter_app/README.md)
- [Website README](website/README.md)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Next.js Documentation](https://nextjs.org/docs)
- [AdMob Documentation](https://developers.google.com/admob)

## 🤝 Support

For questions or issues:
- Email: support@addreel.com
- Documentation: See individual README files
- Issues: Create an issue in your repository

## 📄 License

© 2025 AdReel. All rights reserved.
