import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/admin/presentation/providers/admin_provider.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/fines/presentation/providers/fines_provider.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:library_management_app/features/transactions/presentation/providers/transactions_provider.dart';

/// Staff read-only dashboard — same stats as admin but no action buttons.
class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final roleCounts = ref.watch(userCountByRoleProvider);
    final txnsAsync = ref.watch(transactionsNotifierProvider);
    final totalFines = ref.watch(totalOutstandingAmountProvider);
    final totalUsers = roleCounts.values.fold<int>(0, (s, v) => s + v);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Staff Monitor', style: TextStyle(fontSize: 18)),
            Text(
              user.name,
              style: const TextStyle(
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
            // ── Read-only info banner ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info100),
              ),
              child: const Row(
                children: [
                  Icon(Icons.visibility_rounded,
                      size: 18, color: AppColors.info500),
                  SizedBox(width: 8),
                  Text(
                    'Read-only access — monitoring view',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.info700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── User Stats ──
            const Text(
              'System Overview',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ReadOnlyStat(
                  icon: Icons.people_rounded,
                  label: 'Total Users',
                  value: '$totalUsers',
                  color: AppColors.primary500,
                ),
                const SizedBox(width: 12),
                _ReadOnlyStat(
                  icon: Icons.school_rounded,
                  label: 'Students',
                  value: '${roleCounts[UserRole.student] ?? 0}',
                  color: AppColors.accent500,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Transaction Stats ──
            txnsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorStateWidget(error: e, compact: true),
              data: (txns) {
                final activeCount = txns
                    .where((t) =>
                        t.status == TransactionStatus.issued ||
                        t.status == TransactionStatus.approved)
                    .length;
                final overdueCount =
                    txns.where((t) => t.isOverdue).length;

                return Row(
                  children: [
                    _ReadOnlyStat(
                      icon: Icons.menu_book_rounded,
                      label: 'Active Issues',
                      value: '$activeCount',
                      color: AppColors.success600,
                    ),
                    const SizedBox(width: 12),
                    _ReadOnlyStat(
                      icon: Icons.warning_amber_rounded,
                      label: 'Overdue',
                      value: '$overdueCount',
                      color: AppColors.error500,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ReadOnlyStat(
                  icon: Icons.receipt_long_rounded,
                  label: 'Fines Owed',
                  value: '₹$totalFines',
                  color: AppColors.warning500,
                ),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 24),

            // ── Recent Transactions ──
            const Text(
              'Recent Transactions',
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
                  return const Text('No recent transactions',
                      style:
                          TextStyle(color: AppColors.textTertiary));
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

class _ReadOnlyStat extends StatelessWidget {
  const _ReadOnlyStat({
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
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
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
