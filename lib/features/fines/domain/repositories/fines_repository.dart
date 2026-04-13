import 'package:library_management_app/features/fines/domain/entities/fine_entity.dart';

/// Abstract contract for fine operations.
abstract class FinesRepository {
  Future<List<FineEntity>> getUserFines(String userId);
  Future<List<FineEntity>> getAllFines();
  Future<void> recordPayment(String fineId);
  Future<void> waiveFine(String fineId);
  Future<int> getTotalOutstandingForUser(String userId);
}
