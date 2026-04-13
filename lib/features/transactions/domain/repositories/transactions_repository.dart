import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';

/// Abstract contract for transaction operations.
abstract class TransactionsRepository {
  Future<List<TransactionEntity>> getUserTransactions(String userId);
  Future<List<TransactionEntity>> getAllTransactions();
  Future<TransactionEntity> createRequest({
    required String userId,
    required String userName,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
  });
  Future<void> approveRequest(String transactionId);
  Future<void> rejectRequest(String transactionId, String reason);
  Future<void> issueBook(String transactionId);
  Future<void> returnBook(String transactionId);
}
