import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class AnalyticsService {
  static const String _analyticsKey = 'analytics_data';

  // Track video view
  Future<void> trackVideoView({
    required String adId,
    required String companyId,
    required int watchDuration,
    required bool completed,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final analyticsData = prefs.getString(_analyticsKey) ?? '{}';
      final Map<String, dynamic> analytics = json.decode(analyticsData) as Map<String, dynamic>;

      // Initialize analytics structure if needed
      if (!analytics.containsKey('views')) {
        analytics['views'] = [];
      }
      if (!analytics.containsKey('totalViews')) {
        analytics['totalViews'] = 0;
      }
      if (!analytics.containsKey('totalEarnings')) {
        analytics['totalEarnings'] = 0.0;
      }
      if (!analytics.containsKey('totalCommission')) {
        analytics['totalCommission'] = 0.0;
      }

      // Add view record
      (analytics['views'] as List<dynamic>).add({
        'adId': adId,
        'companyId': companyId,
        'watchDuration': watchDuration,
        'completed': completed,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Update totals
      analytics['totalViews'] = (analytics['totalViews'] as int) + 1;

      // Keep only last 500 views
      if ((analytics['views'] as List<dynamic>).length > 500) {
        analytics['views'] = (analytics['views'] as List<dynamic>).sublist(
          (analytics['views'] as List<dynamic>).length - 500,
        );
      }

      await prefs.setString(_analyticsKey, json.encode(analytics));
    } catch (e) {
      print('Error tracking video view: $e');
    }
  }

  // Track earnings
  Future<void> trackEarnings({
    required double amount,
    required String companyId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final analyticsData = prefs.getString(_analyticsKey) ?? '{}';
      final Map<String, dynamic> analytics = json.decode(analyticsData) as Map<String, dynamic>;

      // Initialize if needed
      if (!analytics.containsKey('totalEarnings')) {
        analytics['totalEarnings'] = 0.0;
      }
      if (!analytics.containsKey('totalCommission')) {
        analytics['totalCommission'] = 0.0;
      }

      // Calculate commission
      final commission = amount * AppConfig.commissionRate;

      // Update totals
      analytics['totalEarnings'] = (analytics['totalEarnings'] as num).toDouble() + amount;
      analytics['totalCommission'] = (analytics['totalCommission'] as num).toDouble() + commission;

      await prefs.setString(_analyticsKey, json.encode(analytics));
    } catch (e) {
      print('Error tracking earnings: $e');
    }
  }

  // Get analytics data
  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final analyticsData = prefs.getString(_analyticsKey) ?? '{}';
      return json.decode(analyticsData) as Map<String, dynamic>;
    } catch (e) {
      print('Error getting analytics: $e');
      return {};
    }
  }

  // Get analytics by company
  Future<Map<String, dynamic>> getAnalyticsByCompany(String companyId) async {
    try {
      final analytics = await getAnalytics();
      final views = analytics['views'] as List<dynamic>? ?? [];
      
      final companyViews = views.where((v) => v['companyId'] == companyId).toList();
      
      return {
        'totalViews': companyViews.length,
        'completedViews': companyViews.where((v) => v['completed'] == true).length,
        'views': companyViews,
      };
    } catch (e) {
      print('Error getting company analytics: $e');
      return {};
    }
  }

  // Reset analytics (for testing)
  Future<void> resetAnalytics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_analyticsKey);
    } catch (e) {
      print('Error resetting analytics: $e');
    }
  }
}
