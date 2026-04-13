import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/fines/presentation/providers/fines_provider.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:library_management_app/features/transactions/presentation/providers/transactions_provider.dart';

/// Librarian home dashboard with stats and quick action cards.
class LibrarianDashboardScreen extends ConsumerWidget {
  const LibrarianDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final txnsAsync = ref.watch(transactionsNotifierProvider);
    final totalOutstanding = ref.watch(totalOutstandingAmountProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${user.name.split(' ').first}!',
              style: const TextStyle(fontSize: 18),
            ),
            const Text(
              'Librarian Dashboard',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Stats Grid ──
            txnsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorStateWidget(error: e, compact: true),
              data: (txns) {
                final pendingCount = txns
                    .where(
                        (t) => t.status == TransactionStatus.requested)
                    .length;
                final activeCount = txns
                    .where((t) =>
                        t.status == TransactionStatus.issued ||
                        t.status == TransactionStatus.approved)
                    .length;
                final overdueCount =
                    txns.where((t) => t.isOverdue).length;

                return Column(
                  children: [
                    Row(
                      children: [
                        _DashStat(
                          icon: Icons.pending_actions_rounded,
                          label: 'Pending',
                          value: '$pendingCount',
                          color: AppColors.warning500,
                        ),
                        const SizedBox(width: 12),
                        _DashStat(
                          icon: Icons.menu_book_rounded,
                          label: 'Active',
                          value: '$activeCount',
                          color: AppColors.primary500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _DashStat(
                          icon: Icons.warning_amber_rounded,
                          label: 'Overdue',
                          value: '$overdueCount',
                          color: AppColors.error500,
                        ),
                        const SizedBox(width: 12),
                        _DashStat(
                          icon: Icons.receipt_long_rounded,
                          label: 'Fines Owed',
                          value: totalOutstanding > 0
                              ? '₹$totalOutstanding'
                              : '₹0',
                          color: totalOutstanding > 0
                              ? AppColors.error600
                              : AppColors.success500,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // ── Quick Actions ──
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _QuickAction(
              icon: Icons.assignment_rounded,
              label: 'Request Queue',
              description: 'Approve, reject, and manage borrow requests',
              color: AppColors.primary500,
              onTap: () => context.go('/librarian/requests'),
            ),
            const SizedBox(height: 10),
            _QuickAction(
              icon: Icons.library_books_rounded,
              label: 'Book Management',
              description: 'Add, edit, or remove books from the catalogue',
              color: AppColors.accent500,
              onTap: () => context.go('/librarian/books'),
            ),
            const SizedBox(height: 10),
            _QuickAction(
              icon: Icons.receipt_long_rounded,
              label: 'Manage Fines',
              description: 'Record payments and waive fines',
              color: AppColors.warning500,
              onTap: () => context.go('/librarian/fines'),
            ),
            const SizedBox(height: 24),

            // ── Recent Activity ──
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            txnsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorStateWidget(error: e, compact: true),
              data: (txns) {
                final recent = txns.take(5).toList();
                if (recent.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.neutral50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'No recent transactions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  );
                }

                return Column(
                  children: recent.map((tx) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Theme.of(context).dividerColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.bookTitle,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${tx.userName} · ${tx.status.label}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (tx.isOverdue)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.error100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Overdue',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashStat extends StatelessWidget {
  const _DashStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 22, color: color.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
