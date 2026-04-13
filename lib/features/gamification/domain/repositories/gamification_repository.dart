import 'package:library_management_app/features/gamification/domain/entities/house_entity.dart';
import 'package:library_management_app/features/gamification/domain/entities/leaderboard_entry_entity.dart';

/// Abstract contract for gamification operations.
abstract class GamificationRepository {
  Future<List<LeaderboardEntryEntity>> getStudentLeaderboard();
  Future<List<HouseEntity>> getHouseLeaderboard();
  Future<List<HouseEntity>> getAvailableHouses();
  Future<void> selectHouse(String userId, String houseId);
}
