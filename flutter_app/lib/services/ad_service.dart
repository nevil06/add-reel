import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import '../config/app_config.dart';

/// Service to manage multiple ad networks
/// Handles initialization and provides a unified interface for ads
class AdService {
  static final AdService _instance = AdService._internal();

  factory AdService() {
    return _instance;
  }

  AdService._internal();

  bool _isAdMobInitialized = false;
  bool _isUnityInitialized = false;
  bool _isFacebookInitialized = false;

  /// Initialize all ad networks
  Future<void> initialize() async {
    await _initializeAdMob();
    await _initializeUnityAds();
    await _initializeFacebookAds();
  }

  Future<void> _initializeAdMob() async {
    if (!kIsWeb) {
      try {
        await MobileAds.instance.initialize();
        _isAdMobInitialized = true;
        print('✅ AdMob initialized');
      } catch (e) {
        print('⚠️ AdMob initialization failed: $e');
      }
    }
  }

  Future<void> _initializeUnityAds() async {
    if (!kIsWeb) {
      try {
        await UnityAds.init(
          gameId: defaultTargetPlatform == TargetPlatform.android
              ? AppConfig.unityGameIdAndroid
              : AppConfig.unityGameIdIOS,
          testMode: AppConfig.unityTestMode,
          onComplete: () {
            _isUnityInitialized = true;
            print('✅ Unity Ads initialized');
          },
          onFailed: (error, message) {
            print('⚠️ Unity Ads initialization failed: $error - $message');
          },
        );
      } catch (e) {
        print('⚠️ Unity Ads initialization error: $e');
      }
    }
  }

  Future<void> _initializeFacebookAds() async {
    if (!kIsWeb) {
      try {
        await FacebookAudienceNetwork.init(
          testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", // Optional: Add your device hash for testing
        );
        _isFacebookInitialized = true;
        print('✅ Facebook Audience Network initialized');
      } catch (e) {
        print('⚠️ Facebook Ads initialization error: $e');
      }
    }
  }

  /// Check if a specific network is ready
  bool isNetworkReady(String network) {
    switch (network.toLowerCase()) {
      case 'admob':
        return _isAdMobInitialized;
      case 'unity':
        return _isUnityInitialized;
      case 'facebook':
        return _isFacebookInitialized;
      default:
        return false;
    }
  }
}
