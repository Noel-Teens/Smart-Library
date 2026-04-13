import 'package:library_management_app/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:library_management_app/features/transactions/domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  const TransactionsRepositoryImpl(this._ds);
  final TransactionsRemoteDataSource _ds;

  @override
  Future<List<TransactionEntity>> getUserTransactions(String userId) =>
      _ds.getUserTransactions(userId);
  @override
  Future<List<TransactionEntity>> getAllTransactions() =>
      _ds.getAllTransactions();
  @override
  Future<TransactionEntity> createRequest({
    required String userId,
    required String userName,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
  }) => _ds.createRequest(
        userId: userId, userName: userName,
        bookId: bookId, bookTitle: bookTitle, bookAuthor: bookAuthor,
      );
  @override
  Future<void> approveRequest(String id) =>
      _ds.updateStatus(id, TransactionStatus.approved);
  @override
  Future<void> rejectRequest(String id, String reason) =>
      _ds.updateStatus(id, TransactionStatus.rejected, reason: reason);
  @override
  Future<void> issueBook(String id) => _ds.issueBook(id);
  @override
  Future<void> returnBook(String id) => _ds.returnBook(id);
}
