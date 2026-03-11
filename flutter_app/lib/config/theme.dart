import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const primaryGreen = Color(0xFF2D5A3D);
  static const accentAmber = Color(0xFFE8A020);
  static const warmCream = Color(0xFFF5F0E8);
  static const softSage = Color(0xFF8FAF96);
  static const darkInk = Color(0xFF1A1A1A);
  static const mediumGray = Color(0xFF6B6B6B);
  static const lightGray = Color(0xFFE8E4DC);

  // Mood colors
  static const moodColors = [
    Color(0xFFE53E3E), // 1 - muy mal
    Color(0xFFED8936), // 2 - mal
    Color(0xFFECC94B), // 3 - regular
    Color(0xFF48BB78), // 4 - bien
    Color(0xFF2D5A3D), // 5 - excelente
  ];

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: warmCream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
      surface: Colors.white,
      primary: primaryGreen,
      secondary: accentAmber,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: darkInk,
        letterSpacing: -1.5,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: darkInk,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: darkInk,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkInk,
        letterSpacing: -0.3,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkInk,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: darkInk,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: mediumGray,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: warmCream,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: darkInk,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: darkInk),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryGreen,
        side: const BorderSide(color: primaryGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightGray, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightGray, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      labelStyle: const TextStyle(color: mediumGray, fontSize: 14),
      hintStyle: const TextStyle(color: softSage, fontSize: 14),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: lightGray, width: 1),
      ),
    ),
  );
}
