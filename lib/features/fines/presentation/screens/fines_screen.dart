import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/utils/error_handler.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/fines/presentation/providers/fines_provider.dart';
import 'package:library_management_app/features/fines/presentation/widgets/fine_summary_card.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';

/// Fines screen — student sees their own fines, librarian sees all.
class FinesScreen extends ConsumerWidget {
  const FinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finesAsync = ref.watch(finesNotifierProvider);
    final totalOutstanding = ref.watch(totalOutstandingAmountProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final isLibrarian = user?.role == UserRole.librarian ||
        user?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(title: const Text('Fines')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(finesNotifierProvider);
        },
        child: finesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorStateWidget(
            error: e,
            onRetry: () => ref.invalidate(finesNotifierProvider),
          ),
          data: (fines) {
            if (fines.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 64, color: AppColors.success500.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'No fines!',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isLibrarian
                                ? 'All accounts are clear'
                                : 'Keep returning books on time!',
                            style: const TextStyle(
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

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Total outstanding banner
                if (totalOutstanding > 0)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.error600, AppColors.error500],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Outstanding',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                '₹$totalOutstanding',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Fine cards
                ...fines.map((fine) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FineSummaryCard(
                        fine: fine,
                        showUserName: isLibrarian,
                        onRecordPayment: isLibrarian && fine.isOutstanding
                            ? () async {
                                try {
                                  await ref
                                      .read(finesNotifierProvider.notifier)
                                      .recordPayment(fine.id);
                                  if (context.mounted) {
                                    showSuccessSnackBar(
                                        context, 'Payment recorded');
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    showErrorSnackBar(context, e);
                                  }
                                }
                              }
                            : null,
                        onWaive: isLibrarian && fine.isOutstanding
                            ? () async {
                                try {
                                  await ref
                                      .read(finesNotifierProvider.notifier)
                                      .waiveFine(fine.id);
                                  if (context.mounted) {
                                    showSuccessSnackBar(
                                        context, 'Fine waived');
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    showErrorSnackBar(context, e);
                                  }
                                }
                              }
                            : null,
                      ),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
