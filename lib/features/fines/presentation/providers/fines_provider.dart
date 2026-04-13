import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/fines/data/datasources/fines_remote_datasource.dart';
import 'package:library_management_app/features/fines/data/datasources/supabase_fines_datasource.dart';
import 'package:library_management_app/features/fines/data/repositories/fines_repository_impl.dart';
import 'package:library_management_app/features/fines/domain/entities/fine_entity.dart';
import 'package:library_management_app/features/fines/domain/repositories/fines_repository.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';

final _finesDsProvider = Provider<FinesRemoteDataSource>((ref) {
  return SupabaseFinesDataSource();
});

final finesRepositoryProvider = Provider<FinesRepository>((ref) {
  return FinesRepositoryImpl(ref.watch(_finesDsProvider));
});

// ──────────────────────────────────────────────
// Fines Notifier
// ──────────────────────────────────────────────
final finesNotifierProvider =
    AsyncNotifierProvider<FinesNotifier, List<FineEntity>>(FinesNotifier.new);

class FinesNotifier extends AsyncNotifier<List<FineEntity>> {
  @override
  Future<List<FineEntity>> build() async {
    final repo = ref.read(finesRepositoryProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    if (user == null) return [];

    if (user.role == UserRole.librarian || user.role == UserRole.admin) {
      return repo.getAllFines();
    }
    return repo.getUserFines(user.id);
  }

  Future<void> recordPayment(String fineId) async {
    final repo = ref.read(finesRepositoryProvider);
    await repo.recordPayment(fineId);
    ref.invalidateSelf();
  }

  Future<void> waiveFine(String fineId) async {
    final repo = ref.read(finesRepositoryProvider);
    await repo.waiveFine(fineId);
    ref.invalidateSelf();
  }
}

// ── Selectors ──
final outstandingFinesProvider = Provider<List<FineEntity>>((ref) {
  final fines = ref.watch(finesNotifierProvider).valueOrNull ?? [];
  return fines.where((f) => f.isOutstanding).toList();
});

final totalOutstandingAmountProvider = Provider<int>((ref) {
  final outstanding = ref.watch(outstandingFinesProvider);
  return outstanding.fold<int>(0, (sum, f) => sum + f.amount);
});
