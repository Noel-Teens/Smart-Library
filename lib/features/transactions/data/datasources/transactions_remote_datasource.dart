import 'package:library_management_app/features/transactions/data/models/transaction_model.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';

/// Contract for the transactions remote data source.
abstract class TransactionsRemoteDataSource {
  Future<List<TransactionModel>> getUserTransactions(String userId);
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel> createRequest({
    required String userId,
    required String userName,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
  });
  Future<void> updateStatus(String id, TransactionStatus status, {String? reason});
  Future<void> issueBook(String id);
  Future<void> returnBook(String id);
}
