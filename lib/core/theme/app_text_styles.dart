import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography scale for the Smart Library Management System.
///
/// Uses the Inter font family (bundled offline in assets/fonts/).
/// Falls back to the platform default if Inter is not available.
abstract final class AppTextStyles {
  static const String _fontFamily = 'Inter';

  // ──────────────────────────────────────────────
  // Display
  // ──────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
    color: AppColors.textPrimary,
  );

  // ──────────────────────────────────────────────
  // Headline
  // ──────────────────────────────────────────────
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  // ──────────────────────────────────────────────
  // Title
  // ──────────────────────────────────────────────
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  // ──────────────────────────────────────────────
  // Body
  // ──────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textTertiary,
  );

  // ──────────────────────────────────────────────
  // Label
  // ──────────────────────────────────────────────
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.textTertiary,
  );

  // ──────────────────────────────────────────────
  // Convenience: Complete TextTheme
  // ──────────────────────────────────────────────
  static TextTheme get textTheme => const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );

  /// Dark variant swaps text colours to light-on-dark.
  static TextTheme get darkTextTheme => TextTheme(
        displayLarge: displayLarge.copyWith(color: AppColors.darkPrimaryText),
        displayMedium: displayMedium.copyWith(color: AppColors.darkPrimaryText),
        displaySmall: displaySmall.copyWith(color: AppColors.darkPrimaryText),
        headlineLarge: headlineLarge.copyWith(color: AppColors.darkPrimaryText),
        headlineMedium:
            headlineMedium.copyWith(color: AppColors.darkPrimaryText),
        headlineSmall: headlineSmall.copyWith(color: AppColors.darkPrimaryText),
        titleLarge: titleLarge.copyWith(color: AppColors.darkPrimaryText),
        titleMedium: titleMedium.copyWith(color: AppColors.darkPrimaryText),
        titleSmall: titleSmall.copyWith(color: AppColors.darkPrimaryText),
        bodyLarge: bodyLarge.copyWith(color: AppColors.darkPrimaryText),
        bodyMedium: bodyMedium.copyWith(color: AppColors.darkSecondaryText),
        bodySmall: bodySmall.copyWith(color: AppColors.darkTertiaryText),
        labelLarge: labelLarge.copyWith(color: AppColors.darkPrimaryText),
        labelMedium: labelMedium.copyWith(color: AppColors.darkSecondaryText),
        labelSmall: labelSmall.copyWith(color: AppColors.darkTertiaryText),
      );
}
