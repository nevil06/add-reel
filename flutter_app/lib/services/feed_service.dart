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
        // Check if page controller is available and mounted
        if (_pageController == null || !_pageController!.hasClients) {
          return;
        }
        
        // Calculate next index
        final nextIndex = (_currentIndex + 1) % _totalAds;
        
        // Animate to next page
        _pageController!.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        
        // Note: _currentIndex will be updated by onPageChanged callback
        // Don't update it here to avoid race conditions
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
    
    // Only restart auto-scroll timer if enabled and user manually scrolled
    // This prevents conflicts when auto-scroll triggers page changes
    if (_autoScrollEnabled && _autoScrollTimer != null) {
      // Restart the timer to reset the countdown
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
