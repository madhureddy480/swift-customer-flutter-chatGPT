import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand — from 01-Brand.md + ui_ux.png
  static const primary = Color(0xFF583A8E);
  static const primaryVibrant = Color(0xFF662FC1);
  static const primaryLight = Color(0xFF7B5BA8);

  // Onboarding / splash dark canvas (mockup 1A–1C)
  static const onboardingBg = Color(0xFF0F1624);
  static const onboardingSurface = Color(0xFF1A2438);

  // Light app surfaces
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF7F5FA);

  static const textPrimary = Color(0xFF1A1425);
  static const textSecondary = Color(0xFF6B6478);
  static const textTertiary = Color(0xFF9B94A8);
  static const textOnDark = Color(0xFFFFFFFF);
  static const textOnDarkMuted = Color(0xB3FFFFFF);

  static const border = Color(0x1A583A8E);
  static const divider = Color(0xFFE8E4EF);

  static const success = Color(0xFF2E9E5B);
  static const warning = Color(0xFFE8940A);
  static const error = Color(0xFFD64545);
  static const info = Color(0xFF26983E);

  static const navy = Color(0xFF1B2A4A);
  static const promoPurple = Color(0xFF662FC1);
  static const accentOrange = Color(0xFFFF770C);
  static const accentYellow = Color(0xFFF5C518);
  static const accentBlue = Color(0xFF0B60DA);
  static const accentGreen = Color(0xFF49C15A);

  static const darkBackground = Color(0xFF121018);
  static const darkSurface = Color(0xFF1E1A26);
  static const darkSurfaceVariant = Color(0xFF2A2433);
}
