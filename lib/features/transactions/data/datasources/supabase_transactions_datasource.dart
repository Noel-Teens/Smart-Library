import 'package:library_management_app/core/config/supabase_config.dart';
import 'package:library_management_app/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:library_management_app/features/transactions/data/models/transaction_model.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';

/// Supabase implementation of [TransactionsRemoteDataSource].
///
/// Handles the full transaction lifecycle including:
/// - Book issue: decrements available_copies
/// - Book return: increments available_copies, awards points, creates fines
class SupabaseTransactionsDataSource implements TransactionsRemoteDataSource {
  final _client = SupabaseConfig.client;

  /// Fine rate: ₹5 per overdue day.
  static const int _fineRatePerDay = 5;

  /// Points awarded for returning a book on time.
  static const int _onTimeReturnPoints = 10;

  /// Points awarded for returning a book late (still a return, just fewer).
  static const int _lateReturnPoints = 2;

  @override
  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    final data = await _client
        .from('transactions')
        .select()
        .eq('user_id', userId)
        .order('requested_at', ascending: false);
    return data
        .map<TransactionModel>((json) => TransactionModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final data = await _client
        .from('transactions')
        .select()
        .order('requested_at', ascending: false);
    return data
        .map<TransactionModel>((json) => TransactionModel.fromJson(json))
        .toList();
  }

  @override
  Future<TransactionModel> createRequest({
    required String userId,
    required String userName,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
  }) async {
    final data = await _client.from('transactions').insert({
      'user_id': userId,
      'user_name': userName,
      'book_id': bookId,
      'book_title': bookTitle,
      'book_author': bookAuthor,
      'status': 'requested',
    }).select().single();
    return TransactionModel.fromJson(data);
  }

  @override
  Future<void> updateStatus(
    String id,
    TransactionStatus status, {
    String? reason,
  }) async {
    final updates = <String, dynamic>{
      'status': status.name,
    };
    if (status == TransactionStatus.approved) {
      updates['approved_at'] = DateTime.now().toIso8601String();
    }
    if (reason != null) {
      updates['librarian_note'] = reason;
    }
    await _client.from('transactions').update(updates).eq('id', id);
  }

  @override
  Future<void> issueBook(String id) async {
    final now = DateTime.now();

    // 1. Update transaction status to 'issued' with due date (15 days)
    await _client.from('transactions').update({
      'status': 'issued',
      'issued_at': now.toIso8601String(),
      'due_date': now.add(const Duration(days: 15)).toIso8601String(),
    }).eq('id', id);

    // 2. Decrement the book's available_copies
    final txn = await _client
        .from('transactions')
        .select('book_id')
        .eq('id', id)
        .single();
    final bookId = txn['book_id'] as String;

    try {
      await _client.rpc('decrement_available_copies', params: {
        'book_id_param': bookId,
      });
    } catch (_) {
      // Fallback: manual decrement
      final book = await _client
          .from('books')
          .select('available_copies')
          .eq('id', bookId)
          .single();
      final currentCopies = (book['available_copies'] as num).toInt();
      if (currentCopies > 0) {
        await _client.from('books').update({
          'available_copies': currentCopies - 1,
        }).eq('id', bookId);
      }
    }
  }

  @override
  Future<void> returnBook(String id) async {
    final now = DateTime.now();

    // 1. Fetch the full transaction to get due_date, user_id, book info
    final txnData = await _client
        .from('transactions')
        .select()
        .eq('id', id)
        .single();

    final userId = txnData['user_id'] as String;
    final bookId = txnData['book_id'] as String;
    final bookTitle = txnData['book_title'] as String;
    final dueDateStr = txnData['due_date'] as String?;

    // 2. Calculate overdue status
    int overdueDays = 0;
    bool isOverdue = false;
    if (dueDateStr != null) {
      final dueDate = DateTime.parse(dueDateStr);
      if (now.isAfter(dueDate)) {
        isOverdue = true;
        overdueDays = now.difference(dueDate).inDays;
        if (overdueDays < 1) overdueDays = 1; // At least 1 day if past due
      }
    }

    // 3. Determine points to award
    final pointsAwarded = isOverdue ? _lateReturnPoints : _onTimeReturnPoints;

    // 4. Update transaction as returned with points
    await _client.from('transactions').update({
      'status': 'returned',
      'returned_at': now.toIso8601String(),
      'points_awarded': pointsAwarded,
    }).eq('id', id);

    // 5. Increment the book's available_copies
    try {
      await _client.rpc('increment_available_copies', params: {
        'book_id_param': bookId,
      });
    } catch (_) {
      // Fallback: manual increment
      final book = await _client
          .from('books')
          .select('available_copies')
          .eq('id', bookId)
          .single();
      final currentCopies = (book['available_copies'] as num).toInt();
      await _client.from('books').update({
        'available_copies': currentCopies + 1,
      }).eq('id', bookId);
    }

    // 6. If overdue, create a fine record
    if (isOverdue) {
      final fineAmount = overdueDays * _fineRatePerDay;
      await _client.from('fines').insert({
        'transaction_id': id,
        'user_id': userId,
        'book_title': bookTitle,
        'amount': fineAmount,
        'status': 'unpaid',
      });
    }

    // 7. Award points to user profile
    try {
      await _client.rpc('add_user_points', params: {
        'user_id_param': userId,
        'points_param': pointsAwarded,
      });
    } catch (_) {
      // Fallback: manual point addition
      final profile = await _client
          .from('profiles')
          .select('points')
          .eq('id', userId)
          .single();
      final currentPoints = (profile['points'] as num?)?.toInt() ?? 0;
      await _client.from('profiles').update({
        'points': currentPoints + pointsAwarded,
      }).eq('id', userId);
    }

    // 8. Award points to user's house
    try {
      final profile = await _client
          .from('profiles')
          .select('house_id')
          .eq('id', userId)
          .single();
      final houseId = profile['house_id'] as String?;
      if (houseId != null && houseId.isNotEmpty) {
        try {
          await _client.rpc('add_house_points', params: {
            'house_id_param': houseId,
            'points_param': pointsAwarded,
          });
        } catch (_) {
          // Fallback: manual house point addition
          final house = await _client
              .from('houses')
              .select('total_points')
              .eq('id', houseId)
              .single();
          final currentHousePoints =
              (house['total_points'] as num?)?.toInt() ?? 0;
          await _client.from('houses').update({
            'total_points': currentHousePoints + pointsAwarded,
          }).eq('id', houseId);
        }
      }
    } catch (_) {
      // User might not have a house selected — that's fine
    }
  }
}
