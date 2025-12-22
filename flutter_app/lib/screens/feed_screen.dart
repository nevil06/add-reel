import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/ad_model.dart';
import '../services/api_service.dart';
import '../services/points_service.dart';
import '../services/admob_service.dart';
import '../services/analytics_service.dart';
import '../widgets/video_player_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController();
  final RefreshController _refreshController = RefreshController();
  final AdMobService _adMobService = AdMobService();
  final AnalyticsService _analyticsService = AnalyticsService();
  
  List<Ad> _ads = [];
  bool _isLoading = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadAds();
    _adMobService.loadRewardedAd();
  }

  Future<void> _loadAds() async {
    setState(() => _isLoading = true);
    
    final apiService = context.read<ApiService>();
    final ads = await apiService.fetchAds();
    
    setState(() {
      _ads = ads;
      _isLoading = false;
    });
    
    _refreshController.refreshCompleted();
  }

  Future<void> _showRewardedAd() async {
    final pointsService = context.read<PointsService>();
    
    final success = await _adMobService.showRewardedAd(
      onRewarded: (points) async {
        await pointsService.addPoints(points, 'Watched rewarded ad');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 Earned $points points!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      onAdClosed: () {
        // Load next ad
        _adMobService.loadRewardedAd();
      },
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not ready yet. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _refreshController.dispose();
    _adMobService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AdReel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _adMobService.isAdLoaded ? Icons.play_circle : Icons.hourglass_empty,
              color: _adMobService.isAdLoaded ? Colors.green : Colors.grey,
            ),
            onPressed: _adMobService.isAdLoaded ? _showRewardedAd : null,
            tooltip: 'Earn Points',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ads.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.video_library_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No ads available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadAds,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                )
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _loadAds,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: _ads.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      
                      // Track view
                      final ad = _ads[index];
                      _analyticsService.trackVideoView(
                        adId: ad.id,
                        companyId: ad.companyId,
                        watchDuration: 0,
                        completed: false,
                      );
                    },
                    itemBuilder: (context, index) {
                      final ad = _ads[index];
                      return _buildAdCard(ad, index == _currentPage);
                    },
                  ),
                ),
    );
  }

  Widget _buildAdCard(Ad ad, bool isCurrentPage) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video Player
        VideoPlayerWidget(
          videoUrl: ad.videoUrl,
          isPlaying: isCurrentPage,
          onVideoEnd: () {
            _analyticsService.trackVideoView(
              adId: ad.id,
              companyId: ad.companyId,
              watchDuration: 30,
              completed: true,
            );
          },
        ),
        
        // Gradient Overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),
        
        // Content Overlay
        Positioned(
          bottom: 100,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  ad.companyName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                ad.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Description
              Text(
                ad.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              
              // CTA Button
              if (ad.ctaText != null && ad.targetUrl != null)
                ElevatedButton(
                  onPressed: () => _launchUrl(ad.targetUrl!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    ad.ctaText!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Side Actions
        Positioned(
          bottom: 100,
          right: 16,
          child: Column(
            children: [
              _buildActionButton(
                icon: Icons.favorite_border,
                label: '0',
                onTap: () {},
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                icon: Icons.share,
                label: 'Share',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
