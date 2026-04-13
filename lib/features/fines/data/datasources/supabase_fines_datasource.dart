import 'package:library_management_app/core/config/supabase_config.dart';
import 'package:library_management_app/features/fines/data/datasources/fines_remote_datasource.dart';
import 'package:library_management_app/features/fines/data/models/fine_model.dart';
import 'package:library_management_app/features/fines/domain/entities/fine_entity.dart';

/// Supabase implementation of [FinesRemoteDataSource].
class SupabaseFinesDataSource implements FinesRemoteDataSource {
  final _client = SupabaseConfig.client;

  @override
  Future<List<FineModel>> getUserFines(String userId) async {
    final data = await _client
        .from('fines')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return data.map<FineModel>((json) => _fromJson(json)).toList();
  }

  @override
  Future<List<FineModel>> getAllFines() async {
    final data = await _client
        .from('fines')
        .select()
        .order('created_at', ascending: false);
    return data.map<FineModel>((json) => _fromJson(json)).toList();
  }

  @override
  Future<void> recordPayment(String fineId) async {
    await _client.from('fines').update({
      'status': 'paid',
      'paid_at': DateTime.now().toIso8601String(),
    }).eq('id', fineId);
  }

  @override
  Future<void> waiveFine(String fineId) async {
    await _client.from('fines').update({
      'status': 'waived',
    }).eq('id', fineId);
  }

  FineModel _fromJson(Map<String, dynamic> json) {
    return FineModel(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String? ?? '',
      userId: json['user_id'] as String,
      userName: '', // Fetched from join or profile lookups if needed
      bookTitle: json['book_title'] as String? ?? '',
      amount: (json['amount'] as num).toInt(),
      overdueDays: 0, // Calculated on the fly if needed
      status: _parseStatus(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
    );
  }

  FineStatus _parseStatus(String? s) {
    switch (s) {
      case 'paid':
        return FineStatus.paid;
      case 'waived':
        return FineStatus.waived;
      default:
        return FineStatus.pending;
    }
  }
}
