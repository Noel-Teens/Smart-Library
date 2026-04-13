import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Application theme definitions (light and dark).
///
/// Component colours are mapped from the Color Theme Document §7.
abstract final class AppTheme {
  // ──────────────────────────────────────────────
  // Light Theme
  // ──────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Inter',
        colorScheme: _lightColorScheme,
        textTheme: AppTextStyles.textTheme,
        scaffoldBackgroundColor: AppColors.neutral50,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary900,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          iconTheme: IconThemeData(color: AppColors.white),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.primary900,
          indicatorColor: AppColors.accent500.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              );
            }
            return const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF93BADC),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.white);
            }
            return const IconThemeData(color: Color(0xFF6B97BE));
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary600,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.neutral100,
            disabledForegroundColor: AppColors.neutral400,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary600,
            side: const BorderSide(color: AppColors.primary600),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary600,
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.neutral200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.neutral200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary500, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error500),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.error500, width: 2),
          ),
          labelStyle: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.textSecondary,
          ),
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.neutral400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.neutral150),
          ),
          margin: EdgeInsets.zero,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.neutral100,
          labelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.neutral100,
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  // ──────────────────────────────────────────────
  // Dark Theme
  // ──────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        colorScheme: _darkColorScheme,
        textTheme: AppTextStyles.darkTextTheme,
        scaffoldBackgroundColor: AppColors.darkAppBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.neutral900,
          foregroundColor: AppColors.darkPrimaryText,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkPrimaryText,
          ),
          iconTheme: IconThemeData(color: AppColors.darkPrimaryText),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.neutral900,
          indicatorColor: AppColors.accent500.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              );
            }
            return const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.neutral500,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.white);
            }
            return const IconThemeData(color: AppColors.neutral600);
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkPrimaryButton,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.neutral800,
            disabledForegroundColor: AppColors.neutral600,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary400,
            side: const BorderSide(color: AppColors.primary400),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkInputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkInputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkInputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary400, width: 2),
          ),
          labelStyle: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.darkSecondaryText,
          ),
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.neutral600,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkCardSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.darkCardBorder),
          ),
          margin: EdgeInsets.zero,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.neutral800,
          labelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.darkSecondaryText,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkDivider,
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  // ──────────────────────────────────────────────
  // Color Schemes
  // ──────────────────────────────────────────────
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary600,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primary100,
    onPrimaryContainer: AppColors.primary900,
    secondary: AppColors.accent600,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.accent100,
    onSecondaryContainer: AppColors.accent700,
    tertiary: AppColors.accent500,
    onTertiary: AppColors.white,
    error: AppColors.error500,
    onError: AppColors.white,
    errorContainer: AppColors.error100,
    onErrorContainer: AppColors.error700,
    surface: AppColors.white,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.neutral100,
    outline: AppColors.neutral200,
    outlineVariant: AppColors.neutral150,
    shadow: Colors.black26,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimaryButton,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primary800,
    onPrimaryContainer: AppColors.primary200,
    secondary: AppColors.accent500,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.accent700,
    onSecondaryContainer: AppColors.accent200,
    tertiary: AppColors.accent500,
    onTertiary: AppColors.white,
    error: AppColors.error500,
    onError: AppColors.white,
    errorContainer: AppColors.darkErrorBg,
    onErrorContainer: AppColors.error100,
    surface: AppColors.darkCardSurface,
    onSurface: AppColors.darkPrimaryText,
    surfaceContainerHighest: AppColors.neutral800,
    outline: AppColors.neutral700,
    outlineVariant: AppColors.darkCardBorder,
    shadow: Colors.black54,
  );
}
