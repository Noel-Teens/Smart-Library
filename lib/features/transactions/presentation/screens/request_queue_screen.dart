import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/utils/error_handler.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:library_management_app/features/transactions/presentation/providers/transactions_provider.dart';
import 'package:library_management_app/features/transactions/presentation/widgets/transaction_tile.dart';

/// Librarian view: queue of all transactions with action buttons.
class RequestQueueScreen extends ConsumerWidget {
  const RequestQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txnsAsync = ref.watch(transactionsNotifierProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Request Queue'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Active'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: txnsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorStateWidget(
            error: e,
            onRetry: () => ref.invalidate(transactionsNotifierProvider),
          ),
          data: (txns) {
            final pending = txns
                .where((t) => t.status == TransactionStatus.requested)
                .toList();
            final active = txns
                .where((t) => t.status == TransactionStatus.issued)
                .toList();
            final history = txns
                .where((t) =>
                    t.status == TransactionStatus.returned ||
                    t.status == TransactionStatus.rejected)
                .toList();

            return TabBarView(
              children: [
                _buildList(context, ref, pending, _TabType.pending),
                _buildList(context, ref, active, _TabType.active),
                _buildList(context, ref, history, _TabType.history),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref,
      List<TransactionEntity> txns, _TabType tab) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(transactionsNotifierProvider);
      },
      child: txns.isEmpty
          ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tab == _TabType.pending
                              ? Icons.inbox_outlined
                              : tab == _TabType.active
                                  ? Icons.assignment_outlined
                                  : Icons.history,
                          size: 56,
                          color: AppColors.neutral300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tab == _TabType.pending
                              ? 'No pending requests'
                              : tab == _TabType.active
                                  ? 'No active transactions'
                                  : 'No history yet',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: txns.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final tx = txns[index];
                return TransactionTile(
                  transaction: tx,
                  showUserName: true,
                  onIssue: tx.status == TransactionStatus.requested
                      ? () => _issue(context, ref, tx.id)
                      : null,
                  onReject: tx.status == TransactionStatus.requested
                      ? () => _showRejectDialog(context, ref, tx.id)
                      : null,
                  onReturn: tx.status == TransactionStatus.issued
                      ? () => _return(context, ref, tx.id)
                      : null,
                );
              },
            ),
    );
  }



  void _issue(BuildContext context, WidgetRef ref, String id) async {
    try {
      await ref.read(transactionsNotifierProvider.notifier).issueBook(id);
      if (context.mounted) showSuccessSnackBar(context, 'Book issued');
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  void _return(BuildContext context, WidgetRef ref, String id) async {
    try {
      await ref.read(transactionsNotifierProvider.notifier).returnBook(id);
      if (context.mounted) showSuccessSnackBar(context, 'Book returned');
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref, String id) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Request'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Reason for rejection…',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error500,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(transactionsNotifierProvider.notifier)
                  .rejectRequest(id, controller.text.trim());
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}

enum _TabType { pending, active, history }
