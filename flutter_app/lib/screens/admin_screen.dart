import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/analytics_service.dart';
import '../services/points_service.dart';
import '../config/app_config.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final AnalyticsService _analyticsService = AnalyticsService();
  bool _isAuthenticated = false;
  final TextEditingController _passwordController = TextEditingController();
  Map<String, dynamic> _analytics = {};
  
  // TEMPORARY: Use simple password for demo
  // TODO: Implement proper Firebase Admin authentication
  static const String _tempAdminPassword = 'admin123';

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final analytics = await _analyticsService.getAnalytics();
    setState(() {
      _analytics = analytics;
    });
  }

  void _authenticate() {
    if (_passwordController.text == _tempAdminPassword) {
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return _buildLoginScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              setState(() {
                _isAuthenticated = false;
                _passwordController.clear();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAnalytics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Views',
                        '${_analytics['totalViews'] ?? 0}',
                        Icons.visibility,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Total Earnings',
                        AppConfig.formatINR(_analytics['totalEarnings'] ?? 0.0),
                        Icons.attach_money,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Commission',
                        AppConfig.formatINR(_analytics['totalCommission'] ?? 0.0),
                        Icons.account_balance,
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer<PointsService>(
                        builder: (context, pointsService, child) {
                          return _buildStatCard(
                            'User Points',
                            AppConfig.formatPoints(pointsService.totalPoints),
                            Icons.stars,
                            Colors.orange,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Recent Views
                const Text(
                  'Recent Views',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                if (_analytics['views'] == null || (_analytics['views'] as List).isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No views yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ((_analytics['views'] as List).length).clamp(0, 10),
                    itemBuilder: (context, index) {
                      final view = (_analytics['views'] as List)[index];
                      return _buildViewItem(view);
                    },
                  ),

                const SizedBox(height: 24),

                // System Info
                const Text(
                  'System Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
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
                      _buildInfoRow('Commission rate', '${(AppConfig.commissionRate * 100).toInt()}%'),
                      const Divider(),
                      _buildInfoRow('Min withdrawal', AppConfig.formatPoints(AppConfig.minimumWithdrawal)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Danger Zone
                const Text(
                  'Danger Zone',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),

                OutlinedButton.icon(
                  onPressed: () => _showResetDialog(),
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Reset Analytics'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              const Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter password to continue',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                onSubmitted: (_) => _authenticate(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _authenticate,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              Text(
                'Default password: $_tempAdminPassword',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewItem(Map<String, dynamic> view) {
    final completed = view['completed'] as bool? ?? false;
    final timestamp = DateTime.parse(view['timestamp'] as String);
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: completed ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        child: Icon(
          completed ? Icons.check_circle : Icons.play_circle,
          color: completed ? Colors.green : Colors.grey,
        ),
      ),
      title: Text('Ad ID: ${view['adId']}'),
      subtitle: Text(
        '${view['watchDuration']}s • ${_formatTimestamp(timestamp)}',
      ),
      trailing: Text(
        completed ? 'Completed' : 'Partial',
        style: TextStyle(
          color: completed ? Colors.green : Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Analytics'),
        content: const Text(
          'Are you sure you want to reset all analytics data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _analyticsService.resetAnalytics();
              await _loadAnalytics();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analytics reset')),
                );
              }
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
