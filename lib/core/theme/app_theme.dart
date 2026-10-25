import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimary = Color(0xFF006A60);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFF9EF2E4);
  static const Color lightOnPrimaryContainer = Color(0xFF00201C);
  static const Color lightSurface = Color(0xFFF4FBF9);
  static const Color lightOnSurface = Color(0xFF161D1C);

  static const Color darkPrimary = Color(0xFF53DBC9);
  static const Color darkOnPrimary = Color(0xFF003731);
  static const Color darkPrimaryContainer = Color(0xFF005047);
  static const Color darkOnPrimaryContainer = Color(0xFF74F8E5);
  static const Color darkSurface = Color(0xFF0E1514);
  static const Color darkOnSurface = Color(0xFFDDE4E2);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        onPrimary: lightOnPrimary,
        primaryContainer: lightPrimaryContainer,
        onPrimaryContainer: lightOnPrimaryContainer,
        surface: lightSurface,
        onSurface: lightOnSurface,
      ),
      fontFamily: 'Poppins',
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        onPrimary: darkOnPrimary,
        primaryContainer: darkPrimaryContainer,
        onPrimaryContainer: darkOnPrimaryContainer,
        surface: darkSurface,
        onSurface: darkOnSurface,
      ),
      fontFamily: 'Poppins',
    );
  }
}