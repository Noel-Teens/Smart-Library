import 'package:library_management_app/features/gamification/data/datasources/leaderboard_remote_datasource.dart';
import 'package:library_management_app/features/gamification/domain/entities/house_entity.dart';
import 'package:library_management_app/features/gamification/domain/entities/leaderboard_entry_entity.dart';
import 'package:library_management_app/features/gamification/domain/repositories/gamification_repository.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  const GamificationRepositoryImpl(this._ds);
  final LeaderboardRemoteDataSource _ds;

  @override
  Future<List<LeaderboardEntryEntity>> getStudentLeaderboard() =>
      _ds.getStudentLeaderboard();
  @override
  Future<List<HouseEntity>> getHouseLeaderboard() =>
      _ds.getHouseLeaderboard();
  @override
  Future<List<HouseEntity>> getAvailableHouses() =>
      _ds.getAvailableHouses();
  @override
  Future<void> selectHouse(String userId, String houseId) =>
      _ds.selectHouse(userId, houseId);
}
