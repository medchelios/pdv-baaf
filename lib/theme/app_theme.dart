import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs BAAF selon tailwind.config.js
  static const Color brandOrange = Color(0xFFe94d29);
  static const Color brandBlue = Color(0xFF0e4b5b);
  static const Color brandWhite = Color(0xFFffffff);

  // Couleurs dérivées
  static const Color brandOrangeLight = Color(0xFFf5a896);
  static const Color brandOrangeDark = Color(0xFFc73d1a);
  static const Color brandBlueLight = Color(0xFF2d6b7a);
  static const Color brandBlueDark = Color(0xFF0a3a42);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandOrange,
        primary: brandOrange,
        secondary: brandBlue,
        surface: brandWhite,
        background: const Color(0xFFf8f9fa),
        error: Colors.red[700]!,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: brandOrange,
        foregroundColor: brandWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: brandWhite,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandOrange,
          foregroundColor: brandWhite,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: brandWhite,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brandWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[400]!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[600]!, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: brandBlue,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: brandBlue,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: brandBlue,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: brandBlue,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: brandBlue,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: brandBlue,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF374151),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}
