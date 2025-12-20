# AdReel - Video Ads Platform

Complete solution for an Instagram-style reels feed mobile app for video advertisements with admin management website.

## 📦 Project Structure

```
addreel/
├── mobile/              # Expo SDK 54 React Native app
│   ├── src/
│   │   ├── components/  # UI components (VideoCard, etc.)
│   │   ├── config/      # App configuration
│   │   ├── navigation/  # Navigation setup
│   │   ├── screens/     # App screens (Feed, Wallet, Settings, Admin)
│   │   ├── services/    # Business logic services
│   │   └── types/       # TypeScript types
│   ├── App.tsx
│   ├── app.json
│   └── package.json
│
└── website/             # Next.js admin website
    ├── app/
    │   ├── admin/       # Admin dashboard
    │   ├── api/         # API routes
    │   └── page.tsx     # Landing page
    ├── lib/             # Utilities
    ├── public/          # Static files
    └── package.json
```

## 🚀 Quick Start

### Mobile App

```bash
cd mobile
npm install
npm start
```

Scan the QR code with Expo Go to test on your device.

### Website

```bash
cd website
npm install
npm run dev
```

Visit http://localhost:3000 to view the landing page and http://localhost:3000/admin for the admin dashboard.

## ✨ Features

### Mobile App
- ✅ Instagram Reels-style vertical video feed
- ✅ Google AdMob rewarded video ads integration
- ✅ Customizable points system (default: 5,000 points = ₹1)
- ✅ Points wallet with INR conversion
- ✅ Commission tracking for app owner
- ✅ Admin dashboard (password-protected)
- ✅ Settings and user management
- ✅ Offline support with local caching
- ✅ Pull-to-refresh for new ads

### Website
- ✅ Modern, responsive landing page
- ✅ Admin dashboard for ad management
- ✅ Upload, edit, delete video ads
- ✅ Activate/deactivate ads
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

### For You (App Owner)
1. **Deploy website** to Vercel
2. **Access admin dashboard** at `/admin`
3. **Upload video ads** with titles, descriptions, and CTAs
4. **Manage ad queue** - activate, deactivate, reorder
5. **Track analytics** - views, earnings, commission
6. **Configure settings** - points rate, commission, minimums

## ⚙️ Configuration

### Points System

Edit `mobile/src/config/appConfig.ts`:

```typescript
points: {
  pointsPerRewardedAd: 100,      // Points per ad watched
  pointsPerINR: 5000,            // 5000 points = ₹1
  minimumWithdrawal: 10000,      // Minimum to withdraw
}
```

### Commission Rate

```typescript
commission: {
  commissionRate: 0.3,  // 30% of ad revenue
}
```

### AdMob Setup

1. Create AdMob account at https://admob.google.com
2. Create rewarded ad units for iOS and Android
3. Update `mobile/src/config/appConfig.ts` with your Ad Unit IDs
4. Update `mobile/app.json` with your AdMob App IDs

### API Integration

After deploying website to Vercel:

1. Copy your Vercel URL
2. Update `mobile/src/config/appConfig.ts`:
```typescript
api: {
  adsEndpoint: 'https://your-site.vercel.app/api/ads',
}
```

## 📱 Mobile App Screens

- **Feed**: Vertical scrolling video ads with auto-play
- **Wallet**: Points balance, INR value, earnings history
- **Settings**: Account settings, support, legal
- **Admin**: Analytics dashboard (password: admin123)

## 🌐 Website Pages

- **/** - Landing page with hero, features, download CTAs
- **/admin** - Admin dashboard for ad management

## 🔌 API Endpoints

- `GET /api/ads` - Fetch all ads
- `POST /api/ads` - Create new ad
- `PUT /api/ads` - Update ad
- `DELETE /api/ads?id={id}` - Delete ad

## 📊 Admin Dashboard Features

- Upload video ads (MP4, YouTube, Vimeo URLs)
- Add titles, descriptions, CTAs
- Set target URLs for click-through
- Activate/deactivate ads
- Reorder ad queue
- View statistics

## 🚢 Deployment

### Website (Vercel)

```bash
cd website
vercel
```

Or use the Vercel dashboard to import from Git.

### Mobile App

#### iOS
```bash
cd mobile
eas build --platform ios
```

#### Android
```bash
cd mobile
eas build --platform android
```

See [Expo documentation](https://docs.expo.dev/build/introduction/) for detailed build instructions.

## 🔐 Security Notes

- Change admin password in `mobile/src/config/appConfig.ts`
- Add authentication to website admin dashboard for production
- Use environment variables for sensitive data
- Implement rate limiting on API endpoints
- Use HTTPS for all communications

## 📝 Production Checklist

### Mobile App
- [ ] Replace AdMob test IDs with production IDs
- [ ] Update API endpoint to production URL
- [ ] Configure app icons and splash screens
- [ ] Set up app store listings
- [ ] Implement proper error tracking
- [ ] Add analytics (Firebase, Mixpanel)
- [ ] Test on multiple devices
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

## 💡 Customization Ideas

- Add user authentication and profiles
- Implement referral system
- Add daily challenges and bonuses
- Create leaderboards
- Add push notifications
- Implement social sharing
- Add multiple withdrawal methods
- Create advertiser portal
- Add A/B testing for ads
- Implement advanced analytics

## 🐛 Troubleshooting

### Mobile App
- **Videos not playing**: Check video URL format and network connection
- **AdMob ads not showing**: Verify Ad Unit IDs and AdMob account status
- **Points not saving**: Check AsyncStorage permissions

### Website
- **API errors**: Check file permissions for `public/api/ads.json`
- **Build errors**: Ensure Node.js 18+ is installed
- **Deployment issues**: Check Vercel logs

## 📚 Documentation

- [Mobile App README](mobile/README.md)
- [Website README](website/README.md)
- [Expo Documentation](https://docs.expo.dev/)
- [Next.js Documentation](https://nextjs.org/docs)
- [AdMob Documentation](https://developers.google.com/admob)

## 🤝 Support

For questions or issues:
- Email: support@addreel.com
- Documentation: See individual README files
- Issues: Create an issue in your repository

## 📄 License

© 2025 AdReel. All rights reserved.

---

**Built with:**
- React Native & Expo SDK 54
- Next.js 15
- TypeScript
- Tailwind CSS
- Google AdMob
