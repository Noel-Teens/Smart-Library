import 'package:intl/intl.dart' show DateFormat;

/// Convenience extensions on [DateTime].
extension DateTimeExtensions on DateTime {
  /// Formats as 'dd MMM yyyy' — e.g. '11 Apr 2026'.
  String get formatted => DateFormat('dd MMM yyyy').format(this);

  /// Formats as 'dd MMM yyyy, hh:mm a' — e.g. '11 Apr 2026, 02:30 PM'.
  String get formattedWithTime =>
      DateFormat('dd MMM yyyy, hh:mm a').format(this);

  /// Formats as relative text: 'Today', 'Yesterday', or [formatted].
  String get relative {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisDay = DateTime(year, month, day);

    if (thisDay == today) return 'Today';
    if (thisDay == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return formatted;
  }

  /// Number of whole days between this date and [other].
  int daysUntil(DateTime other) {
    final from = DateTime(year, month, day);
    final to = DateTime(other.year, other.month, other.day);
    return to.difference(from).inDays;
  }

  /// Whether this date is strictly before today.
  bool get isPast {
    final now = DateTime.now();
    return isBefore(DateTime(now.year, now.month, now.day));
  }
}
