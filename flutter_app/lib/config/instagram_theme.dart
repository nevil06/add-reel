import 'package:flutter/material.dart';

/// Instagram-inspired theme configuration for AdReel
/// Features Instagram's signature gradient colors and modern UI design
class InstagramTheme {
  // Instagram Brand Colors
  static const Color instagramPurple = Color(0xFF833AB4);
  static const Color instagramPink = Color(0xFFFD1D1D);
  static const Color instagramDeepPink = Color(0xFFE1306C);
  static const Color instagramOrange = Color(0xFFF77737);
  static const Color instagramYellow = Color(0xFFFCAF45);
  static const Color instagramBlue = Color(0xFF3897F0);
  
  // Base Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGray = Color(0xFF262626);
  static const Color mediumGray = Color(0xFF737373);
  static const Color lightGray = Color(0xFFFAFAFA);
  
  // Instagram Gradient
  static const LinearGradient instagramGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      instagramPurple,
      instagramDeepPink,
      instagramOrange,
      instagramYellow,
    ],
  );
  
  // Subtle gradient for backgrounds
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF833AB4),
      Color(0xFFE1306C),
    ],
  );

  /// Dark Theme (Primary theme for video content)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: instagramBlue,
        secondary: instagramDeepPink,
        surface: black,
        background: black,
        error: Color(0xFFED4956),
        onPrimary: white,
        onSecondary: white,
        onSurface: white,
        onBackground: white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: black,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: white),
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
      
      // Bottom Navigation
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: black,
        indicatorColor: instagramBlue.withOpacity(0.2),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: white, size: 28);
          }
          return IconThemeData(color: mediumGray, size: 24);
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(
              color: white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: mediumGray,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          );
        }),
      ),
      
      // Cards
      cardTheme: const CardThemeData(
        color: darkGray,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: instagramBlue,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: instagramBlue,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: instagramBlue, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFED4956)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: mediumGray, fontSize: 14),
        labelStyle: TextStyle(color: mediumGray, fontSize: 14),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: white,
        size: 24,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: white, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: white, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: white, fontSize: 16),
        bodyMedium: TextStyle(color: white, fontSize: 14),
        bodySmall: TextStyle(color: mediumGray, fontSize: 12),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: darkGray,
        thickness: 1,
      ),
    );
  }

  /// Light Theme (Alternative theme)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: instagramBlue,
        secondary: instagramDeepPink,
        surface: white,
        background: lightGray,
        error: Color(0xFFED4956),
        onPrimary: white,
        onSecondary: white,
        onSurface: black,
        onBackground: black,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: white,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: black),
        titleTextStyle: TextStyle(
          color: black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
      
      // Bottom Navigation
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: white,
        indicatorColor: instagramBlue.withOpacity(0.1),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: black, size: 28);
          }
          return IconThemeData(color: mediumGray, size: 24);
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(
              color: black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: mediumGray,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          );
        }),
      ),
      
      // Cards
      cardTheme: const CardThemeData(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: lightGray),
        ),
      ),
      
      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: instagramBlue,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: instagramBlue,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: instagramBlue, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFED4956)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: mediumGray, fontSize: 14),
        labelStyle: TextStyle(color: mediumGray, fontSize: 14),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: black,
        size: 24,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: black, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: black, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: black, fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: black, fontSize: 16),
        bodyMedium: TextStyle(color: black, fontSize: 14),
        bodySmall: TextStyle(color: mediumGray, fontSize: 12),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: lightGray,
        thickness: 1,
      ),
    );
  }
}
