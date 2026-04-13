import 'package:equatable/equatable.dart';

/// Fine status lifecycle.
enum FineStatus {
  pending,
  paid,
  waived;

  String get label {
    switch (this) {
      case FineStatus.pending:
        return 'Pending';
      case FineStatus.paid:
        return 'Paid';
      case FineStatus.waived:
        return 'Waived';
    }
  }
}

/// Domain entity representing a fine on an overdue transaction.
class FineEntity extends Equatable {
  const FineEntity({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.userName,
    required this.bookTitle,
    required this.amount,
    required this.overdueDays,
    required this.status,
    required this.createdAt,
    this.paidAt,
  });

  final String id;
  final String transactionId;
  final String userId;
  final String userName;
  final String bookTitle;

  /// Fine amount in Rs.
  final int amount;

  /// Number of overdue days when the fine was calculated.
  final int overdueDays;
  final FineStatus status;
  final DateTime createdAt;
  final DateTime? paidAt;

  bool get isPaid => status == FineStatus.paid;
  bool get isWaived => status == FineStatus.waived;
  bool get isOutstanding => status == FineStatus.pending;

  @override
  List<Object?> get props => [id, transactionId, userId, amount, status];

  FineEntity copyWith({
    String? id,
    String? transactionId,
    String? userId,
    String? userName,
    String? bookTitle,
    int? amount,
    int? overdueDays,
    FineStatus? status,
    DateTime? createdAt,
    DateTime? paidAt,
  }) {
    return FineEntity(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      bookTitle: bookTitle ?? this.bookTitle,
      amount: amount ?? this.amount,
      overdueDays: overdueDays ?? this.overdueDays,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
