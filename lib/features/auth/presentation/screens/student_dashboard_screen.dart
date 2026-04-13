import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/fines/presentation/providers/fines_provider.dart';
import 'package:library_management_app/features/gamification/presentation/widgets/points_badge.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:library_management_app/features/transactions/presentation/providers/transactions_provider.dart';

/// Student home dashboard with at-a-glance stats and quick actions.
class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final txnsAsync = ref.watch(transactionsNotifierProvider);
    final totalFines = ref.watch(totalOutstandingAmountProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${user.name.split(' ').first}! 👋',
              style: const TextStyle(fontSize: 18),
            ),
            const Text(
              'Welcome to Smart Library',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(transactionsNotifierProvider);
          ref.invalidate(totalOutstandingAmountProvider);
          ref.invalidate(authNotifierProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Points Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary700, AppColors.primary500],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Points',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        PointsBadge(points: user.points, large: true),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Overdue Warning ──
            txnsAsync.whenOrNull(
                  data: (txns) {
                    final overdue = txns.where((t) => t.isOverdue).toList();
                    if (overdue.isEmpty) return const SizedBox.shrink();

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.error100),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.error500, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${overdue.length} book${overdue.length > 1 ? 's' : ''} overdue!',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.error700,
                                  ),
                                ),
                                const Text(
                                  'Return now to avoid fines',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: AppColors.error600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ) ??
                const SizedBox.shrink(),

            // ── Stats Row ──
            Row(
              children: [
                _StatCard(
                  icon: Icons.menu_book_rounded,
                  label: 'Active Borrows',
                  value: txnsAsync.whenOrNull(
                        data: (txns) => txns
                            .where((t) =>
                                t.status == TransactionStatus.issued ||
                                t.status == TransactionStatus.approved)
                            .length
                            .toString(),
                      ) ??
                      '—',
                  color: AppColors.primary500,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.receipt_long_rounded,
                  label: 'Fines Due',
                  value: totalFines > 0 ? '₹$totalFines' : 'None',
                  color: totalFines > 0
                      ? AppColors.error500
                      : AppColors.success500,
                ),
              ],
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
            Row(
              children: [
                _ActionCard(
                  icon: Icons.search_rounded,
                  label: 'Browse Books',
                  color: AppColors.accent500,
                  onTap: () => context.go('/student/books'),
                ),
                const SizedBox(width: 12),
                _ActionCard(
                  icon: Icons.swap_horiz_rounded,
                  label: 'My Borrows',
                  color: AppColors.primary500,
                  onTap: () => context.go('/student/borrows'),
                ),
                const SizedBox(width: 12),
                _ActionCard(
                  icon: Icons.leaderboard_rounded,
                  label: 'Leaderboard',
                  color: AppColors.pointsGold,
                  onTap: () => context.go('/student/leaderboard'),
                ),
              ],
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
                if (txns.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.neutral50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'No recent activity. Start by browsing the catalogue!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  );
                }

                final recent = txns.take(3).toList();
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
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _statusColor(tx.status)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _statusIcon(tx.status),
                              size: 18,
                              color: _statusColor(tx.status),
                            ),
                          ),
                          const SizedBox(width: 12),
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
                                  tx.status.label,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: _statusColor(tx.status),
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
      ),
    );
  }

  Color _statusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.requested:
        return AppColors.info500;
      case TransactionStatus.approved:
        return AppColors.accent500;
      case TransactionStatus.rejected:
        return AppColors.error500;
      case TransactionStatus.issued:
        return AppColors.success600;
      case TransactionStatus.returned:
        return AppColors.neutral500;
    }
  }

  IconData _statusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.requested:
        return Icons.hourglass_top_rounded;
      case TransactionStatus.approved:
        return Icons.check_circle_outline;
      case TransactionStatus.rejected:
        return Icons.cancel_outlined;
      case TransactionStatus.issued:
        return Icons.menu_book_rounded;
      case TransactionStatus.returned:
        return Icons.assignment_return_rounded;
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
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

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
