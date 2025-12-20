// App Configuration
export const APP_CONFIG = {
  // AdMob Configuration (Test IDs - Replace with your actual AdMob IDs)
  admob: {
    // iOS Test Rewarded Ad Unit ID
    iosRewardedAdUnitId: 'ca-app-pub-3940256099942544/1712485313',
    // Android Test Rewarded Ad Unit ID
    androidRewardedAdUnitId: 'ca-app-pub-3940256099942544/5224354917',
  },

  // Points System Configuration
  points: {
    // Points awarded per rewarded ad completion
    pointsPerRewardedAd: 100,
    // Conversion rate: how many points equal 1 INR
    pointsPerINR: 5000,
    // Minimum points required for withdrawal
    minimumWithdrawal: 10000, // 2 INR
  },

  // Commission Configuration
  commission: {
    // Owner commission rate (percentage of ad revenue)
    // Note: This is a placeholder. Actual commission depends on AdMob revenue
    commissionRate: 0.3, // 30%
  },

  // API Configuration
  api: {
    // URL to fetch custom ads from your website
    // Update this to your Vercel deployment URL after deploying the website
    adsEndpoint: 'https://your-website.vercel.app/api/ads',
    // Fallback to local data if API fails
    useFallbackData: true,
  },

  // App Settings
  app: {
    // Auto-play videos in feed
    autoPlayVideos: true,
    // Video completion threshold (percentage)
    videoCompletionThreshold: 0.8, // 80%
    // Refresh interval for ad data (milliseconds)
    adRefreshInterval: 300000, // 5 minutes
  },
};

// Admin Access
export const ADMIN_CONFIG = {
  // Simple password protection for admin screen
  // In production, use proper authentication
  adminPassword: 'admin123',
};
