import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import '../config/app_config.dart';

/// Service to manage Unity Ads
/// Handles rewarded videos, banners, and interstitial ads
class UnityAdsService {
  static final UnityAdsService _instance = UnityAdsService._internal();

  factory UnityAdsService() {
    return _instance;
  }

  UnityAdsService._internal();

  bool _isRewardedAdLoaded = false;
  bool _isInterstitialAdLoaded = false;
  
  bool get isRewardedAdReady => _isRewardedAdLoaded;
  bool get isInterstitialAdReady => _isInterstitialAdLoaded;

  /// Get the appropriate placement ID based on platform
  String get _rewardedPlacementId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return AppConfig.unityRewardedAdPlacementId;
    } else if (Platform.isIOS) {
      return 'Rewarded_iOS';
    }
    return AppConfig.unityRewardedAdPlacementId;
  }

  String get _bannerPlacementId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return AppConfig.unityBannerAdPlacementId;
    } else if (Platform.isIOS) {
      return 'Banner_iOS';
    }
    return AppConfig.unityBannerAdPlacementId;
  }

  String get _interstitialPlacementId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return 'Interstitial_Android';
    } else if (Platform.isIOS) {
      return 'Interstitial_iOS';
    }
    return 'Interstitial_Android';
  }

  /// Load a rewarded video ad
  Future<void> loadRewardedAd() async {
    if (kIsWeb) {
      print('Unity Ads not supported on web');
      return;
    }

    try {
      await UnityAds.load(
        placementId: _rewardedPlacementId,
        onComplete: (placementId) {
          print('✅ Unity Rewarded Ad loaded: $placementId');
          _isRewardedAdLoaded = true;
        },
        onFailed: (placementId, error, message) {
          print('⚠️ Unity Rewarded Ad failed to load: $error - $message');
          _isRewardedAdLoaded = false;
        },
      );
    } catch (e) {
      print('⚠️ Unity Rewarded Ad load error: $e');
      _isRewardedAdLoaded = false;
    }
  }

  /// Load an interstitial ad
  Future<void> loadInterstitialAd() async {
    if (kIsWeb) {
      print('Unity Ads not supported on web');
      return;
    }

    try {
      await UnityAds.load(
        placementId: _interstitialPlacementId,
        onComplete: (placementId) {
          print('✅ Unity Interstitial Ad loaded: $placementId');
          _isInterstitialAdLoaded = true;
        },
        onFailed: (placementId, error, message) {
          print('⚠️ Unity Interstitial Ad failed to load: $error - $message');
          _isInterstitialAdLoaded = false;
        },
      );
    } catch (e) {
      print('⚠️ Unity Interstitial Ad load error: $e');
      _isInterstitialAdLoaded = false;
    }
  }

  /// Show a rewarded video ad
  /// Returns true if user completed the ad and earned reward
  Future<bool> showRewardedAd({
    required Function(int points) onRewarded,
    required Function() onAdClosed,
  }) async {
    if (kIsWeb) {
      print('Unity Ads not supported on web');
      return false;
    }

    if (!_isRewardedAdLoaded) {
      print('⚠️ Unity Rewarded Ad is not ready yet');
      return false;
    }

    bool rewarded = false;

    try {
      await UnityAds.showVideoAd(
        placementId: _rewardedPlacementId,
        onComplete: (placementId) {
          print('✅ Unity Rewarded Ad completed: $placementId');
          rewarded = true;
          onRewarded(AppConfig.pointsPerAd);
          _isRewardedAdLoaded = false;
          // Preload next ad
          loadRewardedAd();
        },
        onFailed: (placementId, error, message) {
          print('⚠️ Unity Rewarded Ad failed to show: $error - $message');
          _isRewardedAdLoaded = false;
          // Try to load again
          loadRewardedAd();
        },
        onStart: (placementId) {
          print('▶️ Unity Rewarded Ad started: $placementId');
        },
        onClick: (placementId) {
          print('👆 Unity Rewarded Ad clicked: $placementId');
        },
        onSkipped: (placementId) {
          print('⏭️ Unity Rewarded Ad skipped: $placementId');
          _isRewardedAdLoaded = false;
          // Preload next ad
          loadRewardedAd();
        },
      );

      // Wait a bit for callbacks to complete
      await Future.delayed(const Duration(milliseconds: 500));
      onAdClosed();
    } catch (e) {
      print('⚠️ Unity Rewarded Ad show error: $e');
      _isRewardedAdLoaded = false;
      return false;
    }

    return rewarded;
  }

  /// Show an interstitial ad
  Future<bool> showInterstitialAd({
    Function()? onAdClosed,
  }) async {
    if (kIsWeb) {
      print('Unity Ads not supported on web');
      return false;
    }

    if (!_isInterstitialAdLoaded) {
      print('⚠️ Unity Interstitial Ad is not ready yet');
      return false;
    }

    bool shown = false;

    try {
      await UnityAds.showVideoAd(
        placementId: _interstitialPlacementId,
        onComplete: (placementId) {
          print('✅ Unity Interstitial Ad completed: $placementId');
          shown = true;
          _isInterstitialAdLoaded = false;
          // Preload next ad
          loadInterstitialAd();
        },
        onFailed: (placementId, error, message) {
          print('⚠️ Unity Interstitial Ad failed to show: $error - $message');
          _isInterstitialAdLoaded = false;
          // Try to load again
          loadInterstitialAd();
        },
        onStart: (placementId) {
          print('▶️ Unity Interstitial Ad started: $placementId');
        },
        onClick: (placementId) {
          print('👆 Unity Interstitial Ad clicked: $placementId');
        },
        onSkipped: (placementId) {
          print('⏭️ Unity Interstitial Ad skipped: $placementId');
          _isInterstitialAdLoaded = false;
          // Preload next ad
          loadInterstitialAd();
        },
      );

      // Wait a bit for callbacks to complete
      await Future.delayed(const Duration(milliseconds: 500));
      onAdClosed?.call();
    } catch (e) {
      print('⚠️ Unity Interstitial Ad show error: $e');
      _isInterstitialAdLoaded = false;
      return false;
    }

    return shown;
  }

  /// Dispose of resources
  void dispose() {
    _isRewardedAdLoaded = false;
    _isInterstitialAdLoaded = false;
  }
}
