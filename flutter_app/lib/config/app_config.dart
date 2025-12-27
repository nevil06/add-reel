class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3000'; // Change to your Vercel URL
  static const String adsEndpoint = '$apiBaseUrl/api/ads';
  static const String companiesEndpoint = '$apiBaseUrl/api/companies';
  
  // AdMob Configuration
  // Set to FALSE to use YOUR production ads (real ads that generate revenue)
  // Set to TRUE to use Google's test ads (for testing only)
  static const bool useTestAds = false; // FALSE = Your production ads!
  
  // Production AdMob App ID
  static const String admobAppId = 'ca-app-pub-7611642022143924~8359601006';
  
  // Test Device IDs - Add your device IDs here to see test ads on YOUR devices only
  // How to get your device ID:
  // 1. Run the app on your device
  // 2. Check logcat (Android) or Xcode console (iOS)
  // 3. Look for: "Use RequestConfiguration.Builder().setTestDeviceIds"
  // 4. Copy the device ID and add it to the list below
  static const List<String> testDeviceIds = [
    // Add your device IDs here (one per line)
    // Example: '33BE2250B43518CCDA7DE426D04EE231',
    // Leave empty if you don't have test device IDs yet
  ];
  
  // Test Ad Unit IDs (Google's official test ad units)
  static const String androidTestRewardedId = 'ca-app-pub-3940256099942544/5224354917';
  static const String iosTestRewardedId = 'ca-app-pub-3940256099942544/1712485313';
  static const String androidTestInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String iosTestInterstitialId = 'ca-app-pub-3940256099942544/4411468910';
  static const String androidTestBannerId = 'ca-app-pub-3940256099942544/6300978111'; // Test banner
  static const String iosTestBannerId = 'ca-app-pub-3940256099942544/2934735716'; // Test banner
  
  // Production Ad Unit IDs - From your AdMob account
  // Rewarded Ad Unit ID: ca-app-pub-7611642022143924/2404405043
  static const String androidProdRewardedId = 'ca-app-pub-7611642022143924/2404405043'; // ✅ Your rewarded ad
  static const String iosProdRewardedId = 'ca-app-pub-7611642022143924/2404405043'; // ✅ Using same for iOS (create separate iOS ad unit if needed)
  static const String androidProdInterstitialId = 'ca-app-pub-7611642022143924/7625760379'; // ✅ Your interstitial ad
  static const String iosProdInterstitialId = 'ca-app-pub-7611642022143924/7625760379'; // ✅ Using same for iOS
  // Banner Ad Unit ID: ca-app-pub-7611642022143924/6044444762
  static const String androidProdBannerId = 'ca-app-pub-7611642022143924/6044444762'; // ✅ Your banner ad
  static const String iosProdBannerId = 'ca-app-pub-7611642022143924/6044444762'; // ✅ Using same for iOS
  
  // Get the appropriate Ad Unit IDs based on platform and test mode
  static String get androidRewardedAdUnitId => useTestAds ? androidTestRewardedId : androidProdRewardedId;
  static String get iosRewardedAdUnitId => useTestAds ? iosTestRewardedId : iosProdRewardedId;
  static String get androidInterstitialAdUnitId => useTestAds ? androidTestInterstitialId : androidProdInterstitialId;
  static String get iosInterstitialAdUnitId => useTestAds ? iosTestInterstitialId : iosProdInterstitialId;
  static String get androidBannerAdUnitId => useTestAds ? androidTestBannerId : androidProdBannerId;
  static String get iosBannerAdUnitId => useTestAds ? iosTestBannerId : iosProdBannerId;
  
  // Points Configuration
  static const int pointsPerRewardedAd = 100;
  static const int pointsPerINR = 5000; // 5000 points = ₹1
  static const int minimumWithdrawal = 10000; // Minimum points to withdraw
  
  // Commission Configuration
  static const double commissionRate = 0.3; // 30% commission
  
  // App Configuration
  static const int adRefreshInterval = 3600000; // 1 hour in milliseconds
  static const bool useFallbackData = true;
  
  // NOTE: Admin authentication now handled via Firebase Admin SDK
  // No hardcoded passwords for security
  
  // Helper Methods
  static double pointsToINR(int points) {
    return points / pointsPerINR;
  }
  
  static int inrToPoints(double inr) {
    return (inr * pointsPerINR).round();
  }
  
  static String formatINR(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
  
  static String formatPoints(int points) {
    return points.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
