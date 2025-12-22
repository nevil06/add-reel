import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_config.dart';

class AdMobService {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  
  bool get isAdLoaded => _isAdLoaded;

  // Get the appropriate ad unit ID based on platform
  String get _adUnitId {
    if (Platform.isAndroid) {
      return AppConfig.androidRewardedAdUnitId;
    } else if (Platform.isIOS) {
      return AppConfig.iosRewardedAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Load rewarded ad
  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
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
              _isAdLoaded = false;
              // Load next ad
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              _isAdLoaded = false;
              // Load next ad
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Failed to load rewarded ad: $error');
          _isAdLoaded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  // Show rewarded ad
  Future<bool> showRewardedAd({
    required Function(int points) onRewarded,
    required Function() onAdClosed,
  }) async {
    if (_rewardedAd == null || !_isAdLoaded) {
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
    _isAdLoaded = false;
  }
}
