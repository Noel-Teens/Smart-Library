import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/admin/domain/entities/audit_log_entity.dart';
import 'package:library_management_app/features/admin/presentation/providers/admin_provider.dart';
import 'package:intl/intl.dart';

/// Chronological audit log screen.
class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(auditLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Audit Logs')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(auditLogsProvider);
        },
        child: logsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorStateWidget(
            error: e,
            onRetry: () => ref.invalidate(auditLogsProvider),
          ),
          data: (logs) {
            if (logs.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    child: const Center(child: Text('No audit logs')),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _AuditLogTile(log: logs[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _AuditLogTile extends StatelessWidget {
  const _AuditLogTile({required this.log});

  final AuditLogEntity log;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _colorFor(log.action).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _iconFor(log.action),
              size: 18,
              color: _colorFor(log.action),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _labelFor(log.action),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _colorFor(log.action),
                  ),
                ),
                const SizedBox(height: 2),
                if (log.details != null)
                  Text(
                    log.details!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 12, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        log.performedByName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (log.targetUserName != null) ...[
                      const Text(' → ',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary)),
                      Flexible(
                        child: Text(
                          log.targetUserName!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (log.targetBookTitle != null) ...[
                      const Text(' → ',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary)),
                      Flexible(
                        child: Text(
                          log.targetBookTitle!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  dateFormat.format(log.timestamp),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String action) {
    switch (action) {
      case 'user_created':
        return Icons.person_add_rounded;
      case 'role_changed':
        return Icons.swap_horiz_rounded;
      case 'account_frozen':
        return Icons.lock_rounded;
      case 'book_added':
        return Icons.add_circle_rounded;
      case 'book_deleted':
        return Icons.delete_rounded;
      case 'fine_waived':
        return Icons.money_off_rounded;
      case 'fine_paid':
        return Icons.payment_rounded;
      case 'bulk_return':
        return Icons.assignment_return_rounded;
      case 'system_backup':
        return Icons.backup_rounded;
      default:
        return Icons.info_outline;
    }
  }

  Color _colorFor(String action) {
    switch (action) {
      case 'user_created':
        return AppColors.success600;
      case 'role_changed':
        return AppColors.primary500;
      case 'account_frozen':
        return AppColors.error500;
      case 'book_added':
        return AppColors.accent500;
      case 'book_deleted':
        return AppColors.error600;
      case 'fine_waived':
      case 'fine_paid':
        return AppColors.warning500;
      case 'bulk_return':
        return AppColors.info500;
      case 'system_backup':
        return AppColors.neutral500;
      default:
        return AppColors.neutral500;
    }
  }

  String _labelFor(String action) {
    switch (action) {
      case 'user_created':
        return 'User Created';
      case 'role_changed':
        return 'Role Changed';
      case 'account_frozen':
        return 'Account Frozen';
      case 'book_added':
        return 'Book Added';
      case 'book_deleted':
        return 'Book Deleted';
      case 'fine_waived':
        return 'Fine Waived';
      case 'fine_paid':
        return 'Fine Paid';
      case 'bulk_return':
        return 'Bulk Return';
      case 'system_backup':
        return 'System Backup';
      default:
        return action.replaceAll('_', ' ');
    }
  }
}
