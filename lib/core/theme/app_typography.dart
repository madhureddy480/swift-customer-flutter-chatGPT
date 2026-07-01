import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTypography {
  // Shared app hierarchy. Keep these tokens as the single source of truth for
  // shell navigation and compact tab content.
  static const pageTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static const pageSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static const sectionTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.1,
  );

  static const cardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const compactCardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );

  static const cardSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 10.5,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static const bodyText = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static const smallLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 10.5,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const compactLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 9,
    fontWeight: FontWeight.w500,
    height: 1.15,
  );

  static const actionLabel = TextStyle(
    color: AppColors.primary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const cardValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const bottomNavLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static TextTheme textTheme(Brightness brightness) {
    final color =
        brightness == Brightness.light ? AppColors.textPrimary : Colors.white;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: 0,
        color: color,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
        color: color,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: color,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      ),
      bodySmall: bodyText,
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.2,
        color: color,
      ),
      labelMedium: bottomNavLabel.copyWith(color: color),
    );
  }
}
