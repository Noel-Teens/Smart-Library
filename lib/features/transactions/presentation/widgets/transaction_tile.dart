import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:library_management_app/features/transactions/presentation/widgets/status_chip.dart';
import 'package:intl/intl.dart';

/// A list tile showing a single transaction with status, dates, and actions.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    this.showUserName = false,
    this.onApprove,
    this.onReject,
    this.onIssue,
    this.onReturn,
  });

  final TransactionEntity transaction;
  final bool showUserName;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onIssue;
  final VoidCallback? onReturn;

  @override
  Widget build(BuildContext context) {
    final tx = transaction;
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.bookTitle,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tx.bookAuthor,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (showUserName) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person_outline,
                                size: 14, color: AppColors.neutral500),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                tx.userName,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                StatusChip(status: tx.status, isOverdue: tx.isOverdue),
              ],
            ),
            const SizedBox(height: 10),

            // ── Date info ──
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                _dateBadge('Requested', dateFormat.format(tx.requestedAt)),
                if (tx.issuedAt != null)
                  _dateBadge('Issued', dateFormat.format(tx.issuedAt!)),
                if (tx.dueDate != null)
                  _dateBadge(
                    'Due',
                    dateFormat.format(tx.dueDate!),
                    isAlert: tx.isOverdue,
                  ),
                if (tx.returnedAt != null)
                  _dateBadge('Returned', dateFormat.format(tx.returnedAt!)),
                if (tx.pointsAwarded > 0)
                  _dateBadge('Points', '+${tx.pointsAwarded}',
                      color: AppColors.pointsGold),
              ],
            ),

            if (tx.rejectionReason != null && tx.rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 14, color: AppColors.error600),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Rejected: ${tx.rejectionReason}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.error700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (tx.isOverdue) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 14, color: AppColors.warning700),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Overdue by ${tx.overdueDays} day${tx.overdueDays == 1 ? '' : 's'} — Fine: ₹${tx.overdueDays * 5}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.warning700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Action buttons (librarian) ──
            if (onApprove != null || onReject != null ||
                onIssue != null || onReturn != null) ...[
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (onReject != null)
                    TextButton(
                      onPressed: onReject,
                      child: const Text('Reject',
                          style: TextStyle(color: AppColors.error500)),
                    ),
                  if (onApprove != null)
                    ElevatedButton(
                      onPressed: onApprove,
                      child: const Text('Approve'),
                    ),
                  if (onIssue != null)
                    ElevatedButton(
                      onPressed: onIssue,
                      child: const Text('Issue Book'),
                    ),
                  if (onReturn != null)
                    ElevatedButton(
                      onPressed: onReturn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success600,
                      ),
                      child: const Text('Process Return'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _dateBadge(String label, String value,
      {bool isAlert = false, Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: AppColors.textTertiary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color ?? (isAlert ? AppColors.error600 : AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
