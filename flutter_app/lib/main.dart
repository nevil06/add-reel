import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/ads_feed_screen.dart'; // NEW: Ads feed with auto-scroll
import 'screens/wallet_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/login_screen.dart';
import 'services/points_service.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/feed_service.dart'; // NEW: Feed service for auto-scroll
import 'config/app_config.dart';
import 'config/instagram_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with web configuration
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDemoKey123456789",
        authDomain: "addreel-demo.firebaseapp.com",
        projectId: "addreel-demo",
        storageBucket: "addreel-demo.appspot.com",
        messagingSenderId: "123456789",
        appId: "1:123456789:web:abc123",
      ),
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('⚠️ Firebase initialization error: $e');
    print('📝 App will run in DEMO mode without authentication');
  }
  
  // Initialize AdMob (only on mobile)
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
    
    // Configure test devices if any are specified
    // This allows YOUR devices to see test ads while others see real ads
    if (AppConfig.testDeviceIds.isNotEmpty) {
      RequestConfiguration requestConfiguration = RequestConfiguration(
        testDeviceIds: AppConfig.testDeviceIds,
      );
      MobileAds.instance.updateRequestConfiguration(requestConfiguration);
      print('✅ AdMob initialized with ${AppConfig.testDeviceIds.length} test device(s)');
    } else {
      print('✅ AdMob initialized (production mode - real ads for all users)');
    }
  } else {
    print('⚠️ AdMob not available on web');
  }
  
  runApp(const AdReelApp());
}

class AdReelApp extends StatelessWidget {
  const AdReelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PointsService()),
        ChangeNotifierProvider(create: (_) => FeedService()), // NEW: Feed service
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'AdReel',
        debugShowCheckedModeBanner: false,
        theme: InstagramTheme.lightTheme,
        darkTheme: InstagramTheme.darkTheme,
        themeMode: ThemeMode.dark, // Default to dark theme for video content
        // Production mode - uses Firebase authentication
        home: const ProductionWrapper(),
      ),
    );
  }
}


// Temporary demo mode for testing without Firebase
class ProductionWrapper extends StatelessWidget {
  const ProductionWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Change back to AuthWrapper after Firebase is configured
    // return const AuthWrapper();
    return const MainScreen(); // Temporary for testing
  }
}

// Auth wrapper to handle login state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            ),
          );
        }
        
        // Show login if not authenticated
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        
        // Show main app if authenticated
        return const MainScreen();
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AdsFeedScreen(), // NEW: Auto-scroll feed with banner ads
    const WalletScreen(),
    const SettingsScreen(),
    const AdminScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline),
            selectedIcon: Icon(Icons.play_circle),
            label: 'Reels',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}
