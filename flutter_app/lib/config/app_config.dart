class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3000'; // Change to your Vercel URL
  static const String adsEndpoint = '$apiBaseUrl/api/ads';
  static const String companiesEndpoint = '$apiBaseUrl/api/companies';
  
  // AdMob Configuration - TEST IDs (Google's official test ad units)
  // IMPORTANT: Replace with your production IDs before releasing to production!
  static const String admobAppId = 'ca-app-pub-3940256099942544~3347511713'; // Test App ID
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910'; // Test Interstitial iOS
  static const String androidRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test Rewarded
  static const String iosRewardedAdUnitId = 'ca-app-pub-3940256099942544/1712485313'; // Test Rewarded iOS
  
  // Points Configuration
  static const int pointsPerRewardedAd = 100;
  static const int pointsPerINR = 5000; // 5000 points = ₹1
  static const int minimumWithdrawal = 10000; // Minimum points to withdraw
  
  // Commission Configuration
  static const double commissionRate = 0.3; // 30% commission
  
  // App Configuration
  static const int adRefreshInterval = 3600000; // 1 hour in milliseconds
  static const bool useFallbackData = true;
  
  // Admin Configuration
  static const String adminPassword = 'admin123';
  
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
