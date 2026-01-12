import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Purples (primary - updated from blue to purple)
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFFF3E8FF);
  static const Color primaryLighter = Color(0xFFFAF5FF);
  static const Color primaryDark = Color(0xFF5B21B6);

  // Backgrounds
  static const Color backgroundStart = Color(0xFFF9FAFB);
  static const Color backgroundEnd = Color(0xFFF3F4F6);

  // Card / glossy
  static const Color cardStart = Color(0xFFFFFFFF);
  static const Color cardEnd = Color(0xFFF9FAFB);
  static const Color glossyOverlay1 = Color(0x66FFFFFF);
  static const Color glossyOverlay2 = Color(0x22FFFFFF);

  // Shadows (neumorphic)
  static const Color shadowDark = Color(0xFFE5E7EB);
  static const Color shadowLight = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  // Helpers: gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF6B46C1), // Purple gradient top
      Color(0xFF9333EA), // Purple gradient middle
      Color(0xFF7C3AED), // Purple gradient bottom
    ],
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