import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Utilise les couleurs d'AppConstants
  static const Color brandOrange = AppConstants.brandOrange;
  static const Color brandBlue = AppConstants.brandBlue;
  static const Color brandWhite = AppConstants.brandWhite;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppConstants.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandOrange,
        primary: brandOrange,
        secondary: brandBlue,
        surface: AppConstants.backgroundColor,
        error: AppConstants.errorColor,
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
      cardTheme: CardThemeData(
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
      textTheme: TextTheme(
        headlineLarge: AppConstants.heading1.copyWith(fontSize: 32),
        headlineMedium: AppConstants.heading1.copyWith(fontSize: 28),
        headlineSmall: AppConstants.heading2.copyWith(fontSize: 24),
        titleLarge: AppConstants.heading2.copyWith(fontSize: 20),
        titleMedium: AppConstants.heading3.copyWith(fontSize: 18),
        titleSmall: AppConstants.heading3.copyWith(fontSize: 16),
        bodyLarge: AppConstants.bodyLarge,
        bodyMedium: AppConstants.bodyMedium,
        bodySmall: AppConstants.bodySmall,
      ),
    );
  }
}
