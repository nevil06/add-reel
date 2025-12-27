import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Service for generating unique device fingerprints
/// Used for fraud detection and preventing duplicate ad views
class DeviceService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static String? _cachedFingerprint;

  /// Generate a unique fingerprint for this device
  /// The fingerprint is based on device-specific identifiers
  /// and is hashed for privacy
  static Future<String> getDeviceFingerprint() async {
    // Return cached fingerprint if available
    if (_cachedFingerprint != null) {
      return _cachedFingerprint!;
    }

    String fingerprint;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        
        // Combine multiple identifiers for uniqueness
        final data = [
          androidInfo.id,
          androidInfo.androidId ?? '',
          androidInfo.model,
          androidInfo.brand,
          androidInfo.device,
        ].join('-');
        
        // Hash the data for privacy
        fingerprint = sha256.convert(utf8.encode(data)).toString();
        
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        
        // Combine multiple identifiers for uniqueness
        final data = [
          iosInfo.identifierForVendor ?? '',
          iosInfo.model,
          iosInfo.systemName,
          iosInfo.systemVersion,
        ].join('-');
        
        // Hash the data for privacy
        fingerprint = sha256.convert(utf8.encode(data)).toString();
        
      } else {
        // Fallback for unsupported platforms
        fingerprint = 'unknown-platform';
      }

      // Cache the fingerprint
      _cachedFingerprint = fingerprint;
      
      return fingerprint;
      
    } catch (e) {
      print('Error generating device fingerprint: $e');
      // Return a fallback fingerprint
      return 'error-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Get device information for analytics
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'platform': 'android',
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'version': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'platform': 'ios',
          'model': iosInfo.model,
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
        };
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
    
    return {'platform': 'unknown'};
  }

  /// Clear cached fingerprint (useful for testing)
  static void clearCache() {
    _cachedFingerprint = null;
  }
}
