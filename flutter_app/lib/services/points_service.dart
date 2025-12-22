import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_points_model.dart';
import '../config/app_config.dart';

class PointsService extends ChangeNotifier {
  int _totalPoints = 0;
  List<PointsTransaction> _transactions = [];
  
  static const String _pointsKey = 'user_points';
  static const String _transactionsKey = 'points_transactions';

  int get totalPoints => _totalPoints;
  double get inrValue => AppConfig.pointsToINR(_totalPoints);
  List<PointsTransaction> get transactions => _transactions;
  bool get canWithdraw => _totalPoints >= AppConfig.minimumWithdrawal;

  PointsService() {
    _loadPoints();
  }

  // Load points from storage
  Future<void> _loadPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _totalPoints = prefs.getInt(_pointsKey) ?? 0;
      
      final transactionsData = prefs.getString(_transactionsKey);
      if (transactionsData != null) {
        final List<dynamic> transactionsJson = json.decode(transactionsData) as List<dynamic>;
        _transactions = transactionsJson
            .map((json) => PointsTransaction.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading points: $e');
    }
  }

  // Save points to storage
  Future<void> _savePoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_pointsKey, _totalPoints);
      
      final transactionsJson = _transactions.map((t) => t.toJson()).toList();
      await prefs.setString(_transactionsKey, json.encode(transactionsJson));
    } catch (e) {
      print('Error saving points: $e');
    }
  }

  // Add points
  Future<void> addPoints(int points, String description) async {
    _totalPoints += points;
    
    final transaction = PointsTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      points: points,
      type: 'earned',
      description: description,
      timestamp: DateTime.now(),
    );
    
    _transactions.insert(0, transaction);
    
    // Keep only last 100 transactions
    if (_transactions.length > 100) {
      _transactions = _transactions.sublist(0, 100);
    }
    
    await _savePoints();
    notifyListeners();
  }

  // Deduct points (for withdrawal)
  Future<bool> deductPoints(int points, String description) async {
    if (_totalPoints < points) {
      return false;
    }
    
    _totalPoints -= points;
    
    final transaction = PointsTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      points: -points,
      type: 'withdrawn',
      description: description,
      timestamp: DateTime.now(),
    );
    
    _transactions.insert(0, transaction);
    
    // Keep only last 100 transactions
    if (_transactions.length > 100) {
      _transactions = _transactions.sublist(0, 100);
    }
    
    await _savePoints();
    notifyListeners();
    return true;
  }

  // Add bonus points
  Future<void> addBonus(int points, String description) async {
    _totalPoints += points;
    
    final transaction = PointsTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      points: points,
      type: 'bonus',
      description: description,
      timestamp: DateTime.now(),
    );
    
    _transactions.insert(0, transaction);
    
    // Keep only last 100 transactions
    if (_transactions.length > 100) {
      _transactions = _transactions.sublist(0, 100);
    }
    
    await _savePoints();
    notifyListeners();
  }

  // Reset points (for testing)
  Future<void> resetPoints() async {
    _totalPoints = 0;
    _transactions = [];
    await _savePoints();
    notifyListeners();
  }
}
