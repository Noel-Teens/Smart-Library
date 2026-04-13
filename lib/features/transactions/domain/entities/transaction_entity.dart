import 'package:equatable/equatable.dart';

/// Status lifecycle of a borrow transaction (PRD §7.4).
enum TransactionStatus {
  requested,
  approved,
  rejected,
  issued,
  returned;

  String get label {
    switch (this) {
      case TransactionStatus.requested:
        return 'Requested';
      case TransactionStatus.approved:
        return 'Approved';
      case TransactionStatus.rejected:
        return 'Rejected';
      case TransactionStatus.issued:
        return 'Issued';
      case TransactionStatus.returned:
        return 'Returned';
    }
  }
}

/// Domain entity representing a single borrow transaction.
class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.status,
    this.rejectionReason,
    required this.requestedAt,
    this.approvedAt,
    this.issuedAt,
    this.dueDate,
    this.returnedAt,
    this.pointsAwarded = 0,
  });

  final String id;
  final String userId;
  final String userName;
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final TransactionStatus status;
  final String? rejectionReason;
  final DateTime requestedAt;
  final DateTime? approvedAt;
  final DateTime? issuedAt;
  final DateTime? dueDate;
  final DateTime? returnedAt;
  final int pointsAwarded;

  /// Whether this transaction is overdue (issued but past due date).
  bool get isOverdue {
    if (status != TransactionStatus.issued) return false;
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Number of overdue days (0 if not overdue).
  int get overdueDays {
    if (!isOverdue || dueDate == null) return 0;
    return DateTime.now().difference(dueDate!).inDays;
  }

  /// Days remaining until due date (negative if overdue).
  int? get daysRemaining {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  @override
  List<Object?> get props => [
        id, userId, bookId, status, requestedAt,
        approvedAt, issuedAt, dueDate, returnedAt,
      ];

  TransactionEntity copyWith({
    String? id,
    String? userId,
    String? userName,
    String? bookId,
    String? bookTitle,
    String? bookAuthor,
    TransactionStatus? status,
    String? rejectionReason,
    DateTime? requestedAt,
    DateTime? approvedAt,
    DateTime? issuedAt,
    DateTime? dueDate,
    DateTime? returnedAt,
    int? pointsAwarded,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      bookAuthor: bookAuthor ?? this.bookAuthor,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      requestedAt: requestedAt ?? this.requestedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      issuedAt: issuedAt ?? this.issuedAt,
      dueDate: dueDate ?? this.dueDate,
      returnedAt: returnedAt ?? this.returnedAt,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
    );
  }
}
