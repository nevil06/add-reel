import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/points_service.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoScroll = false;
  bool _notifications = true;
  bool _dataSaver = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoScroll = prefs.getBool('auto_scroll') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
      _dataSaver = prefs.getBool('data_saver') ?? false;
    });
  }

  Future<void> _saveAutoScroll(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_scroll', value);
    setState(() => _autoScroll = value);
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<PointsService>(
                  builder: (context, pointsService, child) {
                    return Text(
                      '${pointsService.totalPoints} points',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // Account Settings
          _buildSectionHeader('Account'),
          _buildListTile(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () => _showComingSoon(context),
          ),
          _buildListTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: Switch(
              value: _notifications,
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('notifications', value);
                setState(() => _notifications = value);
              },
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () => _showComingSoon(context),
          ),

          const Divider(),

          // App Settings
          _buildSectionHeader('App'),
          _buildListTile(
            context,
            icon: Icons.auto_awesome,
            title: 'Auto-Scroll Videos',
            subtitle: 'Automatically scroll to next video',
            trailing: Switch(
              value: _autoScroll,
              onChanged: _saveAutoScroll,
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {},
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.data_usage,
            title: 'Data Saver',
            trailing: Switch(
              value: _dataSaver,
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('data_saver', value);
                setState(() => _dataSaver = value);
              },
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.storage,
            title: 'Clear Cache',
            onTap: () => _showClearCacheDialog(context),
          ),

          const Divider(),

          // Support
          _buildSectionHeader('Support'),
          _buildListTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & FAQ',
            onTap: () => _showComingSoon(context),
          ),
          _buildListTile(
            context,
            icon: Icons.email_outlined,
            title: 'Contact Us',
            onTap: () => _showComingSoon(context),
          ),
          _buildListTile(
            context,
            icon: Icons.star_outline,
            title: 'Rate App',
            onTap: () => _showComingSoon(context),
          ),

          const Divider(),

          // Legal
          _buildSectionHeader('Legal'),
          _buildListTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _showComingSoon(context),
          ),
          _buildListTile(
            context,
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () => _showComingSoon(context),
          ),

          const Divider(),

          // About
          _buildListTile(
            context,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () => _showAboutDialog(context),
          ),

          const SizedBox(height: 32),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About AdReel'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AdReel - Video Ads Platform'),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Watch video ads and earn points that can be converted to real money!',
              style: TextStyle(fontSize: 14),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authService = context.read<AuthService>();
              await authService.signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
