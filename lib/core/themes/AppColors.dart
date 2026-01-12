import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Blues (primary)
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFFEAF6FF);
  static const Color primaryLighter = Color(0xFFF0FBFF);
  static const Color primaryDark = Color(0xFF1E3A8A);

  // Backgrounds
  static const Color backgroundStart = Color(0xFFEAF6FF);
  static const Color backgroundEnd = Color(0xFFDFF4FF);

  // Card / glossy
  static const Color cardStart = Color(0xFFF5FBFF);
  static const Color cardEnd = Color(0xFFEFF8FF);
  static const Color glossyOverlay1 = Color(0x66FFFFFF);
  static const Color glossyOverlay2 = Color(0x22FFFFFF);

  // Shadows (neumorphic)
  static const Color shadowDark = Color(0xFF9BBFEA);
  static const Color shadowLight = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF1E3A8A);
  static const Color textSecondary = Color(0xFF4A5568);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  // Helpers: gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundStart, backgroundEnd],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardStart, cardEnd],
  );

  static const LinearGradient glossyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glossyOverlay1, glossyOverlay2],
  );
}

// Optional convenient extension to access via BuildContext:
// usage: context.appColors.primary
extension AppColorsExtension on BuildContext {
  AppColors get appColors => const AppColors._();
}