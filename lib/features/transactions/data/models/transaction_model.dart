import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';

/// Data-layer model for [TransactionEntity] with JSON serialisation.
class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.bookId,
    required super.bookTitle,
    required super.bookAuthor,
    required super.status,
    super.rejectionReason,
    required super.requestedAt,
    super.approvedAt,
    super.issuedAt,
    super.dueDate,
    super.returnedAt,
    super.pointsAwarded,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String,
      bookAuthor: json['book_author'] as String,
      status: TransactionStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TransactionStatus.requested,
      ),
      rejectionReason: (json['rejection_reason'] ?? json['librarian_note']) as String?,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'] as String)
          : null,
      issuedAt: json['issued_at'] != null
          ? DateTime.parse(json['issued_at'] as String)
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      returnedAt: json['returned_at'] != null
          ? DateTime.parse(json['returned_at'] as String)
          : null,
      pointsAwarded: (json['points_awarded'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'book_id': bookId,
      'book_title': bookTitle,
      'book_author': bookAuthor,
      'status': status.name,
      'rejection_reason': rejectionReason,
      'requested_at': requestedAt.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'issued_at': issuedAt?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'returned_at': returnedAt?.toIso8601String(),
      'points_awarded': pointsAwarded,
    };
  }

  factory TransactionModel.fromEntity(TransactionEntity e) {
    return TransactionModel(
      id: e.id,
      userId: e.userId,
      userName: e.userName,
      bookId: e.bookId,
      bookTitle: e.bookTitle,
      bookAuthor: e.bookAuthor,
      status: e.status,
      rejectionReason: e.rejectionReason,
      requestedAt: e.requestedAt,
      approvedAt: e.approvedAt,
      issuedAt: e.issuedAt,
      dueDate: e.dueDate,
      returnedAt: e.returnedAt,
      pointsAwarded: e.pointsAwarded,
    );
  }
}
