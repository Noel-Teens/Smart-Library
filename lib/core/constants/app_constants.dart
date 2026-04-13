/// Business rule constants from the PRD and BRD.
abstract final class AppConstants {
  /// Application name.
  static const String appName = 'Smart Library';

  /// One-line tagline used on the login screen.
  static const String appTagline = 'Your gamified reading companion';

  /// Current version label.
  static const String appVersion = 'v1.0.0';

  // ──────────────────────────────────────────────
  // Fine System (PRD §8.3 / BRD BBR-02, BBR-03)
  // ──────────────────────────────────────────────
  /// Number of days from issuance before fines begin accruing.
  static const int gracePeriodDays = 15;

  /// Fine amount in Rs. per overdue day (from day 16 onwards).
  static const int fineRatePerDay = 5;

  // ──────────────────────────────────────────────
  // Gamification (PRD §8.4)
  // ──────────────────────────────────────────────
  /// Points awarded for an on-time book return.
  static const int pointsPerReturn = 10;

  /// Number of houses in the system.
  static const int houseCount = 4;

  /// House names (ordered by index).
  static const List<String> houseNames = [
    'Crimson',
    'Cobalt',
    'Emerald',
    'Amber',
  ];

  // ──────────────────────────────────────────────
  // UI Constants
  // ──────────────────────────────────────────────
  /// Default page padding.
  static const double pagePadding = 16.0;

  /// Default card border radius.
  static const double cardRadius = 16.0;

  /// Default transition duration in milliseconds.
  static const int transitionDurationMs = 300;
}
