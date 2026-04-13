import 'package:flutter/material.dart';

/// All color tokens for the Smart Library Management System.
///
/// Mapped 1:1 from the Color Theme Document. Do not introduce
/// colours outside this file without updating the design spec.
abstract final class AppColors {
  // ──────────────────────────────────────────────
  // 2.1 Primary Blue (Brand Anchor)
  // ──────────────────────────────────────────────
  static const Color primary900 = Color(0xFF0B2545);
  static const Color primary800 = Color(0xFF13315C);
  static const Color primary700 = Color(0xFF1A4A8A);
  static const Color primary600 = Color(0xFF1D5FAD);
  static const Color primary500 = Color(0xFF2575D0);
  static const Color primary400 = Color(0xFF5A9FE0);
  static const Color primary200 = Color(0xFFB8D8F5);
  static const Color primary100 = Color(0xFFDCEEFB);
  static const Color primary50 = Color(0xFFF0F7FD);

  // ──────────────────────────────────────────────
  // 2.2 Accent Teal (Secondary Brand)
  // ──────────────────────────────────────────────
  static const Color accent700 = Color(0xFF0A6B5E);
  static const Color accent600 = Color(0xFF0D897A);
  static const Color accent500 = Color(0xFF12A898);
  static const Color accent200 = Color(0xFFA3E4DD);
  static const Color accent100 = Color(0xFFD4F4F1);

  // ──────────────────────────────────────────────
  // 3.1 Success
  // ──────────────────────────────────────────────
  static const Color success700 = Color(0xFF1A5C2A);
  static const Color success600 = Color(0xFF226B32);
  static const Color success500 = Color(0xFF2D8A42);
  static const Color success100 = Color(0xFFD6F0DC);
  static const Color success50 = Color(0xFFEEF9F1);

  // ──────────────────────────────────────────────
  // 3.2 Warning
  // ──────────────────────────────────────────────
  static const Color warning700 = Color(0xFF7A4500);
  static const Color warning600 = Color(0xFF9C5A00);
  static const Color warning500 = Color(0xFFC47200);
  static const Color warning100 = Color(0xFFFEE9C4);
  static const Color warning50 = Color(0xFFFFF5E5);

  // ──────────────────────────────────────────────
  // 3.3 Error / Danger
  // ──────────────────────────────────────────────
  static const Color error700 = Color(0xFF7B1A1A);
  static const Color error600 = Color(0xFF9C2020);
  static const Color error500 = Color(0xFFC0392B);
  static const Color error100 = Color(0xFFF9D6D5);
  static const Color error50 = Color(0xFFFDF0EF);

  // ──────────────────────────────────────────────
  // 3.4 Informational
  // ──────────────────────────────────────────────
  static const Color info700 = Color(0xFF1A3F6B);
  static const Color info500 = Color(0xFF2475CC);
  static const Color info100 = Color(0xFFDCEEFB);
  static const Color info50 = Color(0xFFF0F7FD);

  // ──────────────────────────────────────────────
  // 4. Neutral and Surface Colors
  // ──────────────────────────────────────────────
  static const Color neutral950 = Color(0xFF0F1214);
  static const Color neutral900 = Color(0xFF1A1D21);
  static const Color neutral800 = Color(0xFF2C3038);
  static const Color neutral700 = Color(0xFF3E4450);
  static const Color neutral600 = Color(0xFF535B6A);
  static const Color neutral500 = Color(0xFF6B7484);
  static const Color neutral400 = Color(0xFF8E97A6);
  static const Color neutral300 = Color(0xFFB8BFC9);
  static const Color neutral200 = Color(0xFFD4D9E1);
  static const Color neutral150 = Color(0xFFE4E8EE);
  static const Color neutral100 = Color(0xFFEFF1F5);
  static const Color neutral50 = Color(0xFFF7F8FA);
  static const Color white = Color(0xFFFFFFFF);

  // ──────────────────────────────────────────────
  // 5.1 House Colors (Gamification)
  // ──────────────────────────────────────────────
  static const Color houseGryffindor = Color(0xFF7F0909);
  static const Color houseGryffindorLight = Color(0xFFFBE9E9);
  static const Color houseGryffindorText = Color(0xFF4A0404);

  static const Color houseSlytherin = Color(0xFF0D6217);
  static const Color houseSlytherinLight = Color(0xFFE5F5E7);
  static const Color houseSlytherinText = Color(0xFF05350B);

  static const Color houseRavenclaw = Color(0xFF0E1A40);
  static const Color houseRavenclawLight = Color(0xFFE6EAF6);
  static const Color houseRavenclawText = Color(0xFF060B1C);

  static const Color houseHufflepuff = Color(0xFFEEB939);
  static const Color houseHufflepuffLight = Color(0xFFFDF7E6);
  static const Color houseHufflepuffText = Color(0xFF72550A);

  // ──────────────────────────────────────────────
  // 5.2 Points and Badges
  // ──────────────────────────────────────────────
  static const Color pointsGold = Color(0xFFD97706);
  static const Color pointsGoldBg = Color(0xFFFEF9EC);
  static const Color pointsGoldText = Color(0xFF92400E);
  static const Color pointsSilver = Color(0xFF6B7280);
  static const Color pointsBronze = Color(0xFF92400E);

  // ──────────────────────────────────────────────
  // 6. Typography Colors
  // ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF374151);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF9FAFB);
  static const Color textLink = Color(0xFF1D5FAD);
  static const Color textLinkHover = Color(0xFF1A4A8A);

  // ──────────────────────────────────────────────
  // 9. Dark Mode Overrides
  // ──────────────────────────────────────────────
  static const Color darkAppBackground = Color(0xFF111318);
  static const Color darkCardSurface = Color(0xFF1E2228);
  static const Color darkCardBorder = Color(0xFF2C3038);
  static const Color darkPrimaryText = Color(0xFFF9FAFB);
  static const Color darkSecondaryText = Color(0xFFD1D5DB);
  static const Color darkTertiaryText = Color(0xFF9CA3AF);
  static const Color darkNavBackground = Color(0xFF0D1117);
  static const Color darkPrimaryButton = Color(0xFF2575D0);
  static const Color darkInputBackground = Color(0xFF1E2228);
  static const Color darkInputBorder = Color(0xFF3E4450);
  static const Color darkDivider = Color(0xFF2C3038);
  static const Color darkSuccessBg = Color(0xFF0F2E17);
  static const Color darkWarningBg = Color(0xFF2E1F00);
  static const Color darkErrorBg = Color(0xFF2E0E0E);
  static const Color darkInfoBg = Color(0xFF0A1C30);
}
