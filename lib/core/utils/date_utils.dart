import 'package:library_management_app/core/constants/app_constants.dart';

/// Date-related utility functions used across the application.
abstract final class AppDateUtils {
  /// Calculates the due date given an [issueDate].
  static DateTime dueDate(DateTime issueDate) {
    return issueDate.add(const Duration(days: AppConstants.gracePeriodDays));
  }

  /// Returns the number of overdue days (0 if not overdue).
  static int overdueDays(DateTime dueDate, [DateTime? today]) {
    final now = today ?? DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(dueDate.year, dueDate.month, dueDate.day))
        .inDays;
    return diff > 0 ? diff : 0;
  }

  /// Calculates the fine amount in Rs. for the given overdue days.
  static int fineAmount(int overdueDays) {
    return overdueDays * AppConstants.fineRatePerDay;
  }

  /// Convenience: calculates fine from issue date to today.
  static int fineForTransaction(DateTime issueDate, [DateTime? today]) {
    final due = dueDate(issueDate);
    return fineAmount(overdueDays(due, today));
  }
}
