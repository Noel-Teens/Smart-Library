import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/transactions/data/datasources/supabase_transactions_datasource.dart';
import 'package:library_management_app/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:library_management_app/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:library_management_app/features/transactions/domain/repositories/transactions_repository.dart';

// ── Shared datasource singleton ──
final _transactionsDsProvider = Provider<TransactionsRemoteDataSource>((ref) {
  return SupabaseTransactionsDataSource();
});

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepositoryImpl(ref.watch(_transactionsDsProvider));
});

// ──────────────────────────────────────────────
// Transactions Notifier
// ──────────────────────────────────────────────
final transactionsNotifierProvider =
    AsyncNotifierProvider<TransactionsNotifier, List<TransactionEntity>>(
  TransactionsNotifier.new,
);

class TransactionsNotifier extends AsyncNotifier<List<TransactionEntity>> {
  @override
  Future<List<TransactionEntity>> build() async {
    final repo = ref.read(transactionsRepositoryProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    if (user == null) return [];

    if (user.role == UserRole.librarian || user.role == UserRole.admin) {
      return repo.getAllTransactions();
    }
    return repo.getUserTransactions(user.id);
  }

  Future<void> createRequest({
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
  }) async {
    final repo = ref.read(transactionsRepositoryProvider);
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.createRequest(
        userId: user.id,
        userName: user.name,
        bookId: bookId,
        bookTitle: bookTitle,
        bookAuthor: bookAuthor,
      );
      return _refresh();
    });
  }

  Future<void> approveRequest(String transactionId) async {
    final repo = ref.read(transactionsRepositoryProvider);
    await repo.approveRequest(transactionId);
    ref.invalidateSelf();
  }

  Future<void> rejectRequest(String transactionId, String reason) async {
    final repo = ref.read(transactionsRepositoryProvider);
    await repo.rejectRequest(transactionId, reason);
    ref.invalidateSelf();
  }

  Future<void> issueBook(String transactionId) async {
    final repo = ref.read(transactionsRepositoryProvider);
    await repo.issueBook(transactionId);
    ref.invalidateSelf();
  }

  Future<void> returnBook(String transactionId) async {
    final repo = ref.read(transactionsRepositoryProvider);
    await repo.returnBook(transactionId);
    ref.invalidateSelf();
  }

  Future<List<TransactionEntity>> _refresh() async {
    final repo = ref.read(transactionsRepositoryProvider);
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) return [];
    if (user.role == UserRole.librarian || user.role == UserRole.admin) {
      return repo.getAllTransactions();
    }
    return repo.getUserTransactions(user.id);
  }
}

// ── Convenience selectors ──
final pendingRequestsProvider = Provider<List<TransactionEntity>>((ref) {
  final txns = ref.watch(transactionsNotifierProvider).valueOrNull ?? [];
  return txns.where((t) => t.status == TransactionStatus.requested).toList();
});

final activeIssuesProvider = Provider<List<TransactionEntity>>((ref) {
  final txns = ref.watch(transactionsNotifierProvider).valueOrNull ?? [];
  return txns
      .where((t) => t.status == TransactionStatus.issued)
      .toList();
});

final overdueProvider = Provider<List<TransactionEntity>>((ref) {
  final txns = ref.watch(transactionsNotifierProvider).valueOrNull ?? [];
  return txns.where((t) => t.isOverdue).toList();
});
