import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/gamification/data/datasources/leaderboard_remote_datasource.dart';
import 'package:library_management_app/features/gamification/data/datasources/supabase_gamification_datasource.dart';
import 'package:library_management_app/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:library_management_app/features/gamification/domain/entities/house_entity.dart';
import 'package:library_management_app/features/gamification/domain/entities/leaderboard_entry_entity.dart';
import 'package:library_management_app/features/gamification/domain/repositories/gamification_repository.dart';

final _leaderboardDsProvider = Provider<LeaderboardRemoteDataSource>((ref) {
  return SupabaseGamificationDataSource();
});

final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return GamificationRepositoryImpl(ref.watch(_leaderboardDsProvider));
});

// ──────────────────────────────────────────────
// Leaderboard Providers
// ──────────────────────────────────────────────
final studentLeaderboardProvider =
    FutureProvider<List<LeaderboardEntryEntity>>((ref) async {
  final repo = ref.watch(gamificationRepositoryProvider);
  return repo.getStudentLeaderboard();
});

final houseLeaderboardProvider =
    FutureProvider<List<HouseEntity>>((ref) async {
  final repo = ref.watch(gamificationRepositoryProvider);
  return repo.getHouseLeaderboard();
});

final availableHousesProvider =
    FutureProvider<List<HouseEntity>>((ref) async {
  final repo = ref.watch(gamificationRepositoryProvider);
  return repo.getAvailableHouses();
});

/// Selects a house and updates the auth user entity.
Future<void> selectHouseAction(WidgetRef ref, String houseId) async {
  final repo = ref.read(gamificationRepositoryProvider);
  final user = ref.read(authNotifierProvider).valueOrNull;
  if (user == null) return;

  await repo.selectHouse(user.id, houseId);
  // Update the user entity with the new house.
  ref.read(authNotifierProvider.notifier).updateHouse(houseId);
}
