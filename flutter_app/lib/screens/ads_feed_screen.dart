import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'dart:async';
import '../services/feed_service.dart';
import '../services/points_service.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';
import '../config/app_config.dart';
import '../models/ad_model.dart';

class AdsFeedScreen extends StatefulWidget {
  const AdsFeedScreen({super.key});

  @override
  State<AdsFeedScreen> createState() => _AdsFeedScreenState();
}

class _AdsFeedScreenState extends State<AdsFeedScreen> {
  late PageController _pageController;
  final List<Ad> _ads = [];
  final Map<String, admob.BannerAd?> _bannerAds = {};
  final Map<String, bool> _adWatched = {};
  final Map<String, int> _watchDurations = {};
  final Map<String, Timer?> _watchTimers = {};
  
  int _currentPage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadAds();
  }

  Future<void> _loadAds() async {
    // Generate sample AdMob banner ads for the feed
    // In production, these would come from your ad network manager
    final sampleAds = List.generate(10, (index) {
      return Ad(
        id: 'admob_$index',
        companyId: 'admob',
        companyName: 'AdMob',
        videoUrl: '',
        title: 'Advertisement ${index + 1}',
        description: 'Watch this ad to earn 5 points',
        isActive: true,
        order: index,
        createdAt: DateTime.now(),
        network: 'admob',
      );
    });

    setState(() {
      _ads.addAll(sampleAds);
      _isLoading = false;
    });

    // Initialize feed service
    final feedService = context.read<FeedService>();
    feedService.setPageController(_pageController, _ads.length);

    // Preload banner ads
    _preloadBannerAds();
  }

  void _preloadBannerAds() {
    for (int i = 0; i < _ads.length && i < 5; i++) {
      _loadBannerAd(i);
    }
  }

  void _loadBannerAd(int index) {
    if (_bannerAds.containsKey(_ads[index].id)) return;

    final ad = admob.BannerAd(
      adUnitId: AppConfig.androidBannerAdUnitId,
      size: admob.AdSize.mediumRectangle,
      request: const admob.AdRequest(),
      listener: admob.BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAds[_ads[index].id] = ad as admob.BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    ad.load();
  }

  void _startWatchTimer(String adId) {
    _watchTimers[adId]?.cancel();
    _watchDurations[adId] = 0;

    _watchTimers[adId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      _watchDurations[adId] = (_watchDurations[adId] ?? 0) + 1;

      // Award points after watching for threshold duration
      if (_watchDurations[adId]! >= AppConfig.adCompletionThreshold &&
          !(_adWatched[adId] ?? false)) {
        _adWatched[adId] = true;
        _awardPoints(adId);
      }
    });
  }

  void _stopWatchTimer(String adId) {
    _watchTimers[adId]?.cancel();
  }

  Future<void> _awardPoints(String adId) async {
    final pointsService = context.read<PointsService>();
    final analyticsService = AnalyticsService();
    final authService = context.read<AuthService>();

    // Award points
    pointsService.addPoints(
      AppConfig.pointsPerAd,
      'Watched ad: $adId',
    );

    // Track in analytics
    final userId = authService.currentUser?.uid ?? 'anonymous';
    await analyticsService.trackAdView(
      adId: adId,
      userId: userId,
      watchDuration: _watchDurations[adId] ?? 0,
      completed: true,
    );

    // Show animated snackbar with premium design
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.stars,
                  color: Colors.amber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Points Earned!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '+${AppConfig.pointsPerAd} points added to wallet',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _toggleLike(Ad ad) async {
    final analyticsService = AnalyticsService();
    final authService = context.read<AuthService>();
    final userId = authService.currentUser?.uid ?? 'anonymous';

    await analyticsService.likeAd(ad.id, userId);

    // Update UI
    setState(() {
      final index = _ads.indexWhere((a) => a.id == ad.id);
      if (index != -1) {
        _ads[index] = Ad(
          id: ad.id,
          companyId: ad.companyId,
          companyName: ad.companyName,
          videoUrl: ad.videoUrl,
          title: ad.title,
          description: ad.description,
          thumbnailUrl: ad.thumbnailUrl,
          ctaText: ad.ctaText,
          targetUrl: ad.targetUrl,
          isActive: ad.isActive,
          order: ad.order,
          createdAt: ad.createdAt,
          likes: ad.likes + 1,
          isLiked: !ad.isLiked,
          network: ad.network,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main feed
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _ads.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });

              // Stop previous ad timer
              if (index > 0) {
                _stopWatchTimer(_ads[index - 1].id);
              }

              // Start current ad timer
              _startWatchTimer(_ads[index].id);

              // Preload next ads
              if (index + 2 < _ads.length) {
                _loadBannerAd(index + 2);
              }

              // Update feed service
              context.read<FeedService>().updateCurrentIndex(index);
            },
            itemBuilder: (context, index) {
              return _buildAdCard(_ads[index]);
            },
          ),

          // Top controls
          Positioned(
            top: 50,
            right: 20,
            child: _buildTopControls(),
          ),

          // Bottom info
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: _buildAdInfo(_ads[_currentPage]),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard(Ad ad) {
    final bannerAd = _bannerAds[ad.id];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a0a2e),
            const Color(0xFF0a0a1a),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Banner ad with glassmorphism container
            if (bannerAd != null)
              Container(
                width: bannerAd.size.width.toDouble() + 20,
                height: bannerAd.size.height.toDouble() + 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: admob.AdWidget(ad: bannerAd),
                ),
              )
            else
              Container(
                width: 320,
                height: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Watch timer with animation
            if (_watchDurations[ad.id] != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981),
                      const Color(0xFF059669),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_watchDurations[ad.id]}s / ${AppConfig.adCompletionThreshold}s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Consumer<FeedService>(
      builder: (context, feedService, child) {
        return Column(
          children: [
            // Auto-scroll toggle
            IconButton(
              icon: Icon(
                feedService.autoScrollEnabled
                    ? Icons.play_circle_filled
                    : Icons.play_circle_outline,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                feedService.toggleAutoScroll(!feedService.autoScrollEnabled);
              },
            ),

            const SizedBox(height: 8),

            // Auto-play toggle
            IconButton(
              icon: Icon(
                feedService.autoPlayEnabled
                    ? Icons.autorenew
                    : Icons.autorenew_outlined,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                feedService.toggleAutoPlay(!feedService.autoPlayEnabled);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdInfo(Ad ad) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          ad.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        // Description
        Text(
          ad.description,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 16),

        // Actions row
        Row(
          children: [
            // Like button
            GestureDetector(
              onTap: () => _toggleLike(ad),
              child: Column(
                children: [
                  Icon(
                    ad.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: ad.isLiked ? Colors.red : Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ad.likes}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Network badge
            Chip(
              label: Text(
                ad.network.toUpperCase(),
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: Colors.blue,
              padding: EdgeInsets.zero,
            ),

            const SizedBox(width: 8),

            // Points indicator
            Chip(
              label: Text(
                '+${AppConfig.pointsPerAd} pts',
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: Colors.green,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var timer in _watchTimers.values) {
      timer?.cancel();
    }
    for (var ad in _bannerAds.values) {
      ad?.dispose();
    }
    super.dispose();
  }
}
