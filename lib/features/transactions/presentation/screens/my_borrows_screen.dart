import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:library_management_app/features/transactions/presentation/providers/transactions_provider.dart';
import 'package:library_management_app/features/transactions/presentation/widgets/transaction_tile.dart';

/// Student's view of their borrow transactions.
class MyBorrowsScreen extends ConsumerWidget {
  const MyBorrowsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txnsAsync = ref.watch(transactionsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Borrows')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(transactionsNotifierProvider);
        },
        child: txnsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorStateWidget(
            error: e,
            onRetry: () => ref.invalidate(transactionsNotifierProvider),
          ),
          data: (txns) {
            if (txns.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book_outlined,
                              size: 64, color: AppColors.neutral300),
                          const SizedBox(height: 16),
                          const Text(
                            'No borrows yet',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Request a book from the catalogue!',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            // Group by status
            final overdue = txns.where((t) => t.isOverdue).toList();
            final active = txns
                .where((t) =>
                    t.status == TransactionStatus.issued && !t.isOverdue)
                .toList();
            final pending = txns
                .where((t) => t.status == TransactionStatus.requested)
                .toList();
            final history = txns
                .where((t) =>
                    t.status == TransactionStatus.returned ||
                    t.status == TransactionStatus.rejected)
                .toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (overdue.isNotEmpty) ...[
                  _sectionHeader('⚠️ Overdue', AppColors.error600),
                  ...overdue.map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TransactionTile(transaction: t),
                      )),
                  const SizedBox(height: 8),
                ],
                if (active.isNotEmpty) ...[
                  _sectionHeader('Active', AppColors.success600),
                  ...active.map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TransactionTile(transaction: t),
                      )),
                  const SizedBox(height: 8),
                ],
                if (pending.isNotEmpty) ...[
                  _sectionHeader('Pending Requests', AppColors.info700),
                  ...pending.map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TransactionTile(transaction: t),
                      )),
                  const SizedBox(height: 8),
                ],
                if (history.isNotEmpty) ...[
                  _sectionHeader('History', AppColors.neutral500),
                  ...history.map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TransactionTile(transaction: t),
                      )),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
