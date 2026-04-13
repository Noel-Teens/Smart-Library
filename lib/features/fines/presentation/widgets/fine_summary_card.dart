import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/features/fines/domain/entities/fine_entity.dart';
import 'package:intl/intl.dart';

/// Card showing a single fine with status and optional payment action.
class FineSummaryCard extends StatelessWidget {
  const FineSummaryCard({
    super.key,
    required this.fine,
    this.showUserName = false,
    this.onRecordPayment,
    this.onWaive,
  });

  final FineEntity fine;
  final bool showUserName;
  final VoidCallback? onRecordPayment;
  final VoidCallback? onWaive;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final Color statusBg;
    final Color statusFg;

    switch (fine.status) {
      case FineStatus.pending:
        statusBg = AppColors.warning100;
        statusFg = AppColors.warning700;
      case FineStatus.paid:
        statusBg = AppColors.success100;
        statusFg = AppColors.success700;
      case FineStatus.waived:
        statusBg = AppColors.neutral100;
        statusFg = AppColors.neutral700;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fine.bookTitle,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (showUserName) ...[
                        const SizedBox(height: 2),
                        Text(
                          fine.userName,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    fine.status.label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusFg,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Amount
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: fine.isOutstanding
                        ? AppColors.error50
                        : AppColors.neutral50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₹${fine.amount}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: fine.isOutstanding
                          ? AppColors.error600
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      '${fine.overdueDays} day${fine.overdueDays == 1 ? '' : 's'} overdue',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Created ${dateFormat.format(fine.createdAt)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (fine.paidAt != null)
                      Text(
                        'Paid ${dateFormat.format(fine.paidAt!)}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.success600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (fine.isOutstanding &&
                (onRecordPayment != null || onWaive != null)) ...[
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (onWaive != null)
                    TextButton(
                      onPressed: onWaive,
                      child: const Text('Waive'),
                    ),
                  if (onRecordPayment != null)
                    ElevatedButton.icon(
                      onPressed: onRecordPayment,
                      icon: const Icon(Icons.payment, size: 16),
                      label: const Text('Record Payment'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
