import 'package:library_management_app/features/fines/data/datasources/fines_remote_datasource.dart';
import 'package:library_management_app/features/fines/domain/entities/fine_entity.dart';
import 'package:library_management_app/features/fines/domain/repositories/fines_repository.dart';

class FinesRepositoryImpl implements FinesRepository {
  const FinesRepositoryImpl(this._ds);
  final FinesRemoteDataSource _ds;

  @override
  Future<List<FineEntity>> getUserFines(String userId) =>
      _ds.getUserFines(userId);
  @override
  Future<List<FineEntity>> getAllFines() => _ds.getAllFines();
  @override
  Future<void> recordPayment(String fineId) => _ds.recordPayment(fineId);
  @override
  Future<void> waiveFine(String fineId) => _ds.waiveFine(fineId);
  @override
  Future<int> getTotalOutstandingForUser(String userId) async {
    final fines = await _ds.getUserFines(userId);
    return fines
        .where((f) => f.isOutstanding)
        .fold<int>(0, (sum, f) => sum + f.amount);
  }
}
