import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/points_service.dart';
import '../services/admob_service.dart';
import '../config/app_config.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final AdMobService _adMobService = AdMobService();

  @override
  void initState() {
    super.initState();
    _adMobService.loadRewardedAd();
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

  @override
  void dispose() {
    _adMobService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        centerTitle: true,
      ),
      body: Consumer<PointsService>(
        builder: (context, pointsService, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Balance Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Balance',
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
                      const Text(
                        'Points',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '≈ ${AppConfig.formatINR(pointsService.inrValue)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _adMobService.isAdLoaded ? _showRewardedAd : null,
                          icon: const Icon(Icons.play_circle),
                          label: const Text('Earn Points'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: pointsService.canWithdraw
                              ? () => _showWithdrawDialog(context, pointsService)
                              : null,
                          icon: const Icon(Icons.account_balance_wallet),
                          label: const Text('Withdraw'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Info Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Points per ad', '${AppConfig.pointsPerRewardedAd}'),
                      const Divider(),
                      _buildInfoRow('Conversion rate', '${AppConfig.pointsPerINR} points = ₹1'),
                      const Divider(),
                      _buildInfoRow('Minimum withdrawal', AppConfig.formatPoints(AppConfig.minimumWithdrawal)),
                    ],
                  ),
                ),

                // Transaction History
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      pointsService.transactions.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Text(
                                  'No transactions yet',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pointsService.transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = pointsService.transactions[index];
                                return _buildTransactionItem(transaction);
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(transaction) {
    final isPositive = transaction.points > 0;
    final icon = transaction.type == 'earned'
        ? Icons.play_circle
        : transaction.type == 'bonus'
            ? Icons.card_giftcard
            : Icons.account_balance_wallet;
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPositive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        child: Icon(
          icon,
          color: isPositive ? Colors.green : Colors.red,
        ),
      ),
      title: Text(transaction.description),
      subtitle: Text(
        DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.timestamp),
      ),
      trailing: Text(
        '${isPositive ? '+' : ''}${transaction.points}',
        style: TextStyle(
          color: isPositive ? Colors.green : Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, PointsService pointsService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Points'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available: ${AppConfig.formatPoints(pointsService.totalPoints)} points'),
            Text('Value: ${AppConfig.formatINR(pointsService.inrValue)}'),
            const SizedBox(height: 16),
            const Text(
              'Withdrawal feature coming soon!',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
