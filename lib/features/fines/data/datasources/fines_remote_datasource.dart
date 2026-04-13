import 'package:library_management_app/features/fines/data/models/fine_model.dart';

/// Contract for the fines remote data source.
abstract class FinesRemoteDataSource {
  Future<List<FineModel>> getUserFines(String userId);
  Future<List<FineModel>> getAllFines();
  Future<void> recordPayment(String fineId);
  Future<void> waiveFine(String fineId);
}
