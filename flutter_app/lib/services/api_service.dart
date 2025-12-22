import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ad_model.dart';
import '../models/company_model.dart';
import '../config/app_config.dart';

class ApiService {
  static const String _cacheKey = 'cached_ads';
  static const String _lastFetchKey = 'last_fetch_time';

  // Fetch ads from API
  Future<List<Ad>> fetchAds({String? companyId}) async {
    try {
      String url = AppConfig.adsEndpoint;
      if (companyId != null) {
        url += '?companyId=$companyId';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> adsJson = data['ads'] as List<dynamic>;
        final ads = adsJson.map((json) => Ad.fromJson(json as Map<String, dynamic>)).toList();

        // Cache the ads
        await _cacheAds(ads);
        await _updateLastFetchTime();

        // Filter active ads and sort by order
        return ads.where((ad) => ad.isActive).toList()
          ..sort((a, b) => a.order.compareTo(b.order));
      } else {
        throw Exception('Failed to load ads: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ads: $e');
      
      // Return cached ads if available
      if (AppConfig.useFallbackData) {
        return await getCachedAds();
      }
      
      return [];
    }
  }

  // Get cached ads
  Future<List<Ad>> getCachedAds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      
      if (cachedData != null) {
        final List<dynamic> adsJson = json.decode(cachedData) as List<dynamic>;
        return adsJson.map((json) => Ad.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print('Error getting cached ads: $e');
    }
    
    return [];
  }

  // Cache ads locally
  Future<void> _cacheAds(List<Ad> ads) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final adsJson = ads.map((ad) => ad.toJson()).toList();
      await prefs.setString(_cacheKey, json.encode(adsJson));
    } catch (e) {
      print('Error caching ads: $e');
    }
  }

  // Update last fetch time
  Future<void> _updateLastFetchTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastFetchKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error updating last fetch time: $e');
    }
  }

  // Check if ads need refresh
  Future<bool> needsRefresh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastFetch = prefs.getInt(_lastFetchKey);
      
      if (lastFetch == null) return true;
      
      final timeDiff = DateTime.now().millisecondsSinceEpoch - lastFetch;
      return timeDiff > AppConfig.adRefreshInterval;
    } catch (e) {
      return true;
    }
  }

  // Fetch companies
  Future<List<Company>> fetchCompanies() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.companiesEndpoint));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> companiesJson = data['companies'] as List<dynamic>;
        return companiesJson.map((json) => Company.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load companies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching companies: $e');
      return [];
    }
  }

  // Track ad impression
  Future<void> trackImpression({
    required String adId,
    required bool completed,
    required int watchDuration,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final impressionsData = prefs.getString('impressions') ?? '[]';
      final List<dynamic> impressions = json.decode(impressionsData) as List<dynamic>;

      impressions.add({
        'adId': adId,
        'timestamp': DateTime.now().toIso8601String(),
        'completed': completed,
        'watchDuration': watchDuration,
      });

      // Keep only last 100 impressions
      final recentImpressions = impressions.length > 100
          ? impressions.sublist(impressions.length - 100)
          : impressions;

      await prefs.setString('impressions', json.encode(recentImpressions));
    } catch (e) {
      print('Error tracking impression: $e');
    }
  }
}
