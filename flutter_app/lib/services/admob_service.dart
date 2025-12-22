import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_config.dart';

class AdMobService {
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  bool _isRewardedAdLoaded = false;
  bool _isInterstitialAdLoaded = false;
  
  bool get isAdLoaded => _isRewardedAdLoaded || _isInterstitialAdLoaded;

  // Get the appropriate ad unit ID based on platform
  String get _rewardedAdUnitId {
    if (kIsWeb) {
      return ''; // Web not supported
    }
    if (Platform.isAndroid) {
      return AppConfig.androidRewardedAdUnitId;
    } else if (Platform.isIOS) {
      return AppConfig.iosRewardedAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  String get _interstitialAdUnitId {
    if (kIsWeb) {
      return ''; // Web not supported
    }
    if (Platform.isAndroid) {
      return AppConfig.androidInterstitialAdUnitId;
    } else if (Platform.isIOS) {
      return AppConfig.iosInterstitialAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Load rewarded ad
  Future<void> loadRewardedAd() async {
    if (kIsWeb) {
      print('AdMob not supported on web');
      return;
    }
    
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;
          print('Rewarded ad loaded successfully');
          
          // Set up ad callbacks
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('Rewarded ad showed full screen content');
            },
            onAdDismissedFullScreenContent: (ad) {
              print('Rewarded ad dismissed');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdLoaded = false;
              // Load next ad
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdLoaded = false;
              // Load next ad
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Failed to load rewarded ad: $error');
          _isRewardedAdLoaded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  // Load interstitial ad
  Future<void> loadInterstitialAd() async {
    if (kIsWeb) {
      print('AdMob not supported on web');
      return;
    }

    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          print('Interstitial ad loaded successfully');

          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded = false;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Failed to load interstitial ad: $error');
          _isInterstitialAdLoaded = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  // Show rewarded ad
  Future<bool> showRewardedAd({
    required Function(int points) onRewarded,
    required Function() onAdClosed,
  }) async {
    if (_rewardedAd == null || !_isRewardedAdLoaded) {
      print('Rewarded ad is not ready yet');
      return false;
    }

    bool rewarded = false;

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
        rewarded = true;
        onRewarded(AppConfig.pointsPerRewardedAd);
      },
    );

    // Wait for ad to close
    await Future.delayed(const Duration(milliseconds: 500));
    onAdClosed();

    return rewarded;
  }

  // Dispose of the ad
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdLoaded = false;
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded = false;
  }
}
