import 'package:flutter/material.dart';

class AppColors {
  static Color get primaryLightest => AppColorsSystem.light.primary[100]!;
  static Color get primaryLight => AppColorsSystem.light.primary[200]!;
  static Color get primaryMedium => AppColorsSystem.light.primary[300]!;
  static Color get primaryMain => AppColorsSystem.light.primary[500]!;
  static Color get primaryDark => AppColorsSystem.light.primary[900]!;

  static Color get secondaryLight => AppColorsSystem.light.secondary[200]!;
  static Color get secondary => AppColorsSystem.light.secondary[500]!;
  static Color get secondaryDark => AppColorsSystem.light.secondary[900]!;

  static Color get white => AppColorsSystem.light.neutral[100]!;
  static Color get neutralLightest => AppColorsSystem.light.neutral[300]!;
  static Color get neutralLight => AppColorsSystem.light.neutral[400]!;
  static Color get neutralMedium => AppColorsSystem.light.neutral[500]!;
  static Color get neutralDark => AppColorsSystem.light.neutral[700]!;
  static Color get black => AppColorsSystem.light.neutral[900]!;

  static Color get error => AppColorsSystem.light.error;
  static Color get success => AppColorsSystem.light.success;
  static Color get pending => AppColorsSystem.light.pending;
}

class AppColorsSystem {
  static AppColorsSystem light = AppColorsSystem.lightFactory();
  static AppColorsSystem dart = AppColorsSystem.darkFactory();

  MaterialColor primary;
  MaterialColor secondary;
  MaterialColor neutral;
  Color error;
  Color success;
  Color pending;

  AppColorsSystem({
    required this.primary,
    required this.secondary,
    required this.neutral,
    required this.error,
    required this.success,
    required this.pending,
  });

  factory AppColorsSystem.lightFactory() {
    return AppColorsSystem(
      primary: MaterialColor(
        0xFF0682f9,
        <int, Color>{
          50: const Color(0xFFccf0ff).withOpacity(0.5),
          100: const Color(0xFFccf0ff),
          200: const Color(0xFF99dcff),
          300: const Color(0xFF3faaff),
          500: const Color(0xFF0682f9),
          700: const Color(0xFF0682f9),
          900: const Color(0xFF00257a),
        },
      ),
      secondary: const MaterialColor(
        0xFFf98209,
        <int, Color>{
          200: Color(0xFFffc367),
          500: Color(0xFFf98209),
          900: Color(0xFFb74b01),
        },
      ),
      neutral: const MaterialColor(
        0xFF8a99a8,
        <int, Color>{
          100: Color(0xFFF8FCFC),
          300: Color(0xFFEEF0F2),
          400: Color(0xFFc4ccd3),
          500: Color(0xFF8a99a8),
          700: Color(0xFF3d4c5c),
          900: Color(0xFF020d17),
        },
      ),
      error: const Color(0xFFdb2a36),
      success: const Color(0xFF31ac47),
      pending: const Color(0xFFdbc114),
    );
  }

  factory AppColorsSystem.darkFactory() {
    return AppColorsSystem(
      primary: MaterialColor(
        0xFF0682f9,
        <int, Color>{
          50: const Color(0xFFccf0ff).withOpacity(0.5),
          100: const Color(0xFFccf0ff),
          200: const Color(0xFF99dcff),
          300: const Color(0xFF3faaff),
          500: const Color(0xFF0682f9),
          700: const Color(0xFF0682f9),
          900: const Color(0xFF00257a),
        },
      ),
      secondary: const MaterialColor(
        0xFFf98209,
        <int, Color>{
          200: Color(0xFFffc367),
          500: Color(0xFFf98209),
          900: Color(0xFFb74b01),
        },
      ),
      neutral: const MaterialColor(
        0xFF8a99a8,
        <int, Color>{
          100: Color(0xFF020d17),
          300: Color(0xFFEEF0F2),
          400: Color(0xFFc4ccd3),
          500: Color(0xFF8a99a8),
          700: Color(0xFF3d4c5c),
          900: Color(0xFFF8FCFC),
        },
      ),
      error: const Color(0xFFdb2a36),
      success: const Color(0xFF31ac47),
      pending: const Color(0xFFdbc114),
    );
  }
}
