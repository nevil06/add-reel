import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage the ads feed behavior
/// Handles auto-scroll, auto-play, and feed state
class FeedService extends ChangeNotifier {
  PageController? _pageController;
  Timer? _autoScrollTimer;
  
  bool _autoScrollEnabled = false;
  bool _autoPlayEnabled = false;
  int _currentIndex = 0;
  int _totalAds = 0;
  
  // Auto-scroll interval in seconds
  final int autoScrollInterval = 6;
  
  // Getters
  bool get autoScrollEnabled => _autoScrollEnabled;
  bool get autoPlayEnabled => _autoPlayEnabled;
  int get currentIndex => _currentIndex;
  
  FeedService() {
    _loadPreferences();
  }
  
  /// Load user preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _autoScrollEnabled = prefs.getBool('autoScrollEnabled') ?? false;
    _autoPlayEnabled = prefs.getBool('autoPlayEnabled') ?? false;
    notifyListeners();
  }
  
  /// Save preferences to SharedPreferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoScrollEnabled', _autoScrollEnabled);
    await prefs.setBool('autoPlayEnabled', _autoPlayEnabled);
  }
  
  /// Set the PageController for the feed
  void setPageController(PageController controller, int totalAds) {
    _pageController = controller;
    _totalAds = totalAds;
    
    // Start auto-scroll if enabled
    if (_autoScrollEnabled) {
      _startAutoScroll();
    }
  }
  
  /// Toggle auto-scroll on/off
  void toggleAutoScroll(bool enabled) {
    _autoScrollEnabled = enabled;
    
    if (enabled) {
      _startAutoScroll();
    } else {
      _stopAutoScroll();
    }
    
    _savePreferences();
    notifyListeners();
  }
  
  /// Toggle auto-play on/off
  void toggleAutoPlay(bool enabled) {
    _autoPlayEnabled = enabled;
    _savePreferences();
    notifyListeners();
  }
  
  /// Start auto-scrolling through ads
  void _startAutoScroll() {
    _stopAutoScroll(); // Clear any existing timer
    
    _autoScrollTimer = Timer.periodic(
      Duration(seconds: autoScrollInterval),
      (timer) {
        if (_pageController != null && _currentIndex < _totalAds - 1) {
          _currentIndex++;
          _pageController!.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else if (_currentIndex >= _totalAds - 1) {
          // Loop back to start
          _currentIndex = 0;
          _pageController!.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }
  
  /// Stop auto-scrolling
  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }
  
  /// Update current index when user manually scrolls
  void updateCurrentIndex(int index) {
    _currentIndex = index;
    
    // Restart auto-scroll timer if enabled
    if (_autoScrollEnabled) {
      _startAutoScroll();
    }
    
    notifyListeners();
  }
  
  /// Pause auto-scroll temporarily (e.g., when user interacts)
  void pauseAutoScroll() {
    if (_autoScrollEnabled) {
      _stopAutoScroll();
    }
  }
  
  /// Resume auto-scroll
  void resumeAutoScroll() {
    if (_autoScrollEnabled) {
      _startAutoScroll();
    }
  }
  
  @override
  void dispose() {
    _stopAutoScroll();
    _pageController?.dispose();
    super.dispose();
  }
}
