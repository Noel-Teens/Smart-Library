import 'package:equatable/equatable.dart';

/// Domain entity for an admin audit log entry.
class AuditLogEntity extends Equatable {
  const AuditLogEntity({
    required this.id,
    required this.action,
    required this.performedBy,
    required this.performedByName,
    this.targetUserId,
    this.targetUserName,
    this.targetBookId,
    this.targetBookTitle,
    required this.timestamp,
    this.details,
  });

  final String id;
  final String action; // e.g. 'role_changed', 'book_added', 'fine_waived'
  final String performedBy;
  final String performedByName;
  final String? targetUserId;
  final String? targetUserName;
  final String? targetBookId;
  final String? targetBookTitle;
  final DateTime timestamp;
  final String? details;

  @override
  List<Object?> get props => [
        id,
        action,
        performedBy,
        performedByName,
        targetUserId,
        targetUserName,
        targetBookId,
        targetBookTitle,
        timestamp,
        details,
      ];
}
