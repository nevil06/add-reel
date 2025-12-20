# AdReel - Complete Project Structure

```
addreel/
│
├── mobile/                                    # React Native Mobile App (Expo SDK 54)
│   ├── src/
│   │   ├── components/
│   │   │   └── VideoCard.tsx                 # Instagram Reels-style video card
│   │   │
│   │   ├── config/
│   │   │   └── appConfig.ts                  # App configuration (points, AdMob, API)
│   │   │
│   │   ├── navigation/
│   │   │   └── AppNavigator.tsx              # Bottom tab navigation
│   │   │
│   │   ├── screens/
│   │   │   ├── FeedScreen.tsx                # Main video feed (reels-style)
│   │   │   ├── WalletScreen.tsx              # Points & earnings wallet
│   │   │   ├── SettingsScreen.tsx            # App settings
│   │   │   └── AdminScreen.tsx               # Analytics dashboard
│   │   │
│   │   ├── services/
│   │   │   ├── AdDataService.ts              # Fetch & cache ads from API
│   │   │   ├── AdMobService.ts               # Google AdMob integration
│   │   │   ├── PointsService.ts              # Points management logic
│   │   │   └── AnalyticsService.ts           # Track metrics & commission
│   │   │
│   │   └── types/
│   │       └── index.ts                      # TypeScript type definitions
│   │
│   ├── App.tsx                               # App entry point
│   ├── app.json                              # Expo configuration
│   ├── package.json                          # Dependencies
│   └── README.md                             # Mobile app documentation
│
├── website/                                   # Next.js Website
│   ├── app/
│   │   ├── admin/
│   │   │   └── page.tsx                      # Admin dashboard (ad management)
│   │   │
│   │   ├── api/
│   │   │   └── ads/
│   │   │       └── route.ts                  # API routes (GET/POST/PUT/DELETE)
│   │   │
│   │   ├── layout.tsx                        # Root layout with metadata
│   │   ├── page.tsx                          # Landing page
│   │   └── globals.css                       # Global styles
│   │
│   ├── lib/
│   │   └── adsData.ts                        # Ad data type definitions
│   │
│   ├── public/
│   │   └── api/
│   │       └── ads.json                      # Ad data storage (JSON file)
│   │
│   ├── next.config.js                        # Next.js configuration
│   ├── tailwind.config.ts                    # Tailwind CSS config
│   ├── package.json                          # Dependencies
│   └── README.md                             # Website documentation
│
├── .gitignore                                # Git ignore rules
└── README.md                                 # Root project documentation

```

## 📱 Mobile App Structure

### Components (`mobile/src/components/`)
- **VideoCard.tsx**: Reusable video player component with overlay UI

### Configuration (`mobile/src/config/`)
- **appConfig.ts**: Centralized configuration
  - AdMob ad unit IDs
  - Points conversion rate (5000 points = ₹1)
  - Commission rate (30%)
  - API endpoint URL

### Navigation (`mobile/src/navigation/`)
- **AppNavigator.tsx**: Bottom tab navigation with 4 tabs
  - Feed (video ads)
  - Wallet (points)
  - Settings
  - Admin

### Screens (`mobile/src/screens/`)
- **FeedScreen.tsx**: Main feed with vertical scrolling videos
- **WalletScreen.tsx**: Points balance, INR conversion, withdrawal
- **SettingsScreen.tsx**: Account settings, support, legal
- **AdminScreen.tsx**: Password-protected analytics dashboard

### Services (`mobile/src/services/`)
- **AdDataService.ts**: Fetch ads from API, cache locally
- **AdMobService.ts**: Load and show rewarded video ads
- **PointsService.ts**: Add/deduct points, calculate INR
- **AnalyticsService.ts**: Track views, earnings, commission

### Types (`mobile/src/types/`)
- **index.ts**: TypeScript interfaces for Ad, UserPoints, Analytics

---

## 🌐 Website Structure

### Pages (`website/app/`)
- **page.tsx**: Landing page with hero, features, CTA
- **admin/page.tsx**: Admin dashboard for ad management
- **layout.tsx**: Root layout with SEO metadata

### API Routes (`website/app/api/ads/`)
- **route.ts**: RESTful API endpoints
  - GET: Fetch all ads
  - POST: Create new ad
  - PUT: Update ad
  - DELETE: Delete ad

### Data Storage (`website/public/api/`)
- **ads.json**: JSON file storing ad data
  - Video URL, title, description
  - Thumbnail, CTA text, target URL
  - Active status, order

---

## 🔄 Data Flow

```
┌─────────────────┐
│  Mobile App     │
│  (Expo)         │
└────────┬────────┘
         │
         │ HTTP GET /api/ads
         │
         ▼
┌─────────────────┐
│  Website API    │
│  (Next.js)      │
└────────┬────────┘
         │
         │ Read/Write
         │
         ▼
┌─────────────────┐
│  ads.json       │
│  (Data Storage) │
└─────────────────┘
         ▲
         │
         │ Admin Updates
         │
┌─────────────────┐
│  Admin Dashboard│
│  (Web UI)       │
└─────────────────┘
```

---

## 🚀 Key Features by Location

### Mobile App Features
- ✅ Instagram Reels-style video feed
- ✅ Google AdMob rewarded ads
- ✅ Points system with INR conversion
- ✅ Wallet with earnings tracking
- ✅ Admin analytics dashboard
- ✅ Offline support with caching

### Website Features
- ✅ Modern landing page
- ✅ Admin dashboard for ad management
- ✅ RESTful API for mobile integration
- ✅ CRUD operations for ads
- ✅ Vercel deployment ready

---

## 📦 Dependencies

### Mobile App (`mobile/package.json`)
```json
{
  "expo": "~54.0.30",
  "expo-av": "video playback",
  "expo-linear-gradient": "gradients",
  "@react-navigation/native": "navigation",
  "@react-navigation/bottom-tabs": "tab navigation",
  "react-native-gesture-handler": "gestures",
  "@react-native-async-storage/async-storage": "local storage",
  "@expo/vector-icons": "icons"
}
```

### Website (`website/package.json`)
```json
{
  "next": "15.x",
  "react": "19.x",
  "tailwindcss": "styling"
}
```

---

## 🔧 Configuration Files

### Mobile App
- `app.json`: Expo configuration, AdMob IDs, permissions
- `src/config/appConfig.ts`: Points rate, commission, API endpoint

### Website
- `next.config.js`: Next.js configuration
- `tailwind.config.ts`: Tailwind CSS theme
- `public/api/ads.json`: Ad data storage

---

## 📝 Documentation Files

- `README.md` (root): Project overview
- `mobile/README.md`: Mobile app setup & deployment
- `website/README.md`: Website setup & Vercel deployment
- `PROJECT_STRUCTURE.md`: This file

---

## 🎯 Important Paths

### Mobile App Entry Point
```
mobile/App.tsx → AppNavigator → Screens
```

### Website Entry Point
```
website/app/layout.tsx → page.tsx (landing)
website/app/admin/page.tsx (admin dashboard)
```

### API Endpoint
```
website/app/api/ads/route.ts
```

### Data Storage
```
website/public/api/ads.json
```

---

## 🔐 Security Notes

- Admin password: Set in `mobile/src/config/appConfig.ts`
- AdMob test IDs: Replace in `mobile/src/config/appConfig.ts`
- API endpoint: Update in `mobile/src/config/appConfig.ts` after Vercel deployment

---

## 📊 File Count Summary

- **Mobile App**: ~15 TypeScript files
- **Website**: ~8 TypeScript/TSX files
- **Configuration**: ~6 files
- **Documentation**: 4 README files
- **Total**: ~33 files (excluding node_modules)

---

This structure maintains clean separation of concerns, follows best practices, and is ready for production deployment.
