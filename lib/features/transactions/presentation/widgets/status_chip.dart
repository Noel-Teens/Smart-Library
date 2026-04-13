import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';

/// Coloured chip showing transaction status.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.isOverdue = false});

  final TransactionStatus status;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = isOverdue
        ? (AppColors.error100, AppColors.error700, 'Overdue')
        : _colorsFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  static (Color, Color, String) _colorsFor(TransactionStatus s) {
    switch (s) {
      case TransactionStatus.requested:
        return (AppColors.info100, AppColors.info700, 'Requested');
      case TransactionStatus.approved:
        return (AppColors.accent100, AppColors.accent700, 'Approved');
      case TransactionStatus.rejected:
        return (AppColors.error100, AppColors.error700, 'Rejected');
      case TransactionStatus.issued:
        return (AppColors.success100, AppColors.success700, 'Issued');
      case TransactionStatus.returned:
        return (AppColors.neutral100, AppColors.neutral700, 'Returned');
    }
  }
}
