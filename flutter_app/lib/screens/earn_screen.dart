import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/admob_service.dart';
import '../services/points_service.dart';
import '../config/app_config.dart';

class EarnScreen extends StatefulWidget {
  const EarnScreen({super.key});

  @override
  State<EarnScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  final AdMobService _adMobService = AdMobService();
  bool _isLoadingAd = false;

  @override
  void initState() {
    super.initState();
    // Preload rewarded ad
    _adMobService.loadRewardedAd();
  }

  Future<void> _watchAd() async {
    setState(() {
      _isLoadingAd = true;
    });

    try {
      final pointsService = context.read<PointsService>();
      await _adMobService.showRewardedAd(
        onRewarded: (points) {
          pointsService.addPoints(
            AppConfig.pointsPerRewardedAd,
            'Watched rewarded ad',
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '+${AppConfig.pointsPerRewardedAd} points earned!',
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        onAdClosed: () {
          // Ad closed, reload next ad
          _adMobService.loadRewardedAd();
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load ad: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingAd = false;
      });
      // Preload next ad
      _adMobService.loadRewardedAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earn Points'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Points Display
                Consumer<PointsService>(
                  builder: (context, pointsService, child) {
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Your Balance',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppConfig.formatPoints(pointsService.totalPoints),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppConfig.formatINR(
                                AppConfig.pointsToINR(pointsService.totalPoints),
                              ),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Earn Points Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Watch an Ad',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Earn ${AppConfig.pointsPerRewardedAd} points per ad',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _isLoadingAd ? null : _watchAd,
                            icon: _isLoadingAd
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.play_arrow, size: 28),
                            label: Text(
                              _isLoadingAd ? 'Loading...' : 'Watch Ad',
                              style: const TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Info Cards
                _buildInfoCard(
                  icon: Icons.info_outline,
                  title: 'How it Works',
                  description:
                      '1. Tap "Watch Ad"\n'
                      '2. Watch the full advertisement\n'
                      '3. Earn ${AppConfig.pointsPerRewardedAd} points instantly\n'
                      '4. Repeat to earn more!',
                ),

                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.currency_rupee,
                  title: 'Conversion Rate',
                  description:
                      '${AppConfig.pointsPerINR} points = ₹1\n'
                      'Minimum withdrawal: ${AppConfig.formatPoints(AppConfig.minimumWithdrawal)}',
                ),

                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.tips_and_updates_outlined,
                  title: 'Pro Tips',
                  description:
                      '• Watch ads daily to maximize earnings\n'
                      '• Check your balance in the Wallet tab\n'
                      '• Withdraw once you reach ${AppConfig.formatPoints(AppConfig.minimumWithdrawal)}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
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

  @override
  void dispose() {
    _adMobService.dispose();
    super.dispose();
  }
}
