import 'package:library_management_app/features/fines/domain/entities/fine_entity.dart';

/// Data-layer model for [FineEntity] with JSON serialisation.
class FineModel extends FineEntity {
  const FineModel({
    required super.id,
    required super.transactionId,
    required super.userId,
    required super.userName,
    required super.bookTitle,
    required super.amount,
    required super.overdueDays,
    required super.status,
    required super.createdAt,
    super.paidAt,
  });

  factory FineModel.fromJson(Map<String, dynamic> json) {
    return FineModel(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      bookTitle: json['book_title'] as String,
      amount: (json['amount'] as num).toInt(),
      overdueDays: (json['overdue_days'] as num).toInt(),
      status: FineStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => FineStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'user_id': userId,
      'user_name': userName,
      'book_title': bookTitle,
      'amount': amount,
      'overdue_days': overdueDays,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
    };
  }

  factory FineModel.fromEntity(FineEntity e) {
    return FineModel(
      id: e.id,
      transactionId: e.transactionId,
      userId: e.userId,
      userName: e.userName,
      bookTitle: e.bookTitle,
      amount: e.amount,
      overdueDays: e.overdueDays,
      status: e.status,
      createdAt: e.createdAt,
      paidAt: e.paidAt,
    );
  }
}
