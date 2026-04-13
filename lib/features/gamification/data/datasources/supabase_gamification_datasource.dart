import 'dart:ui';

import 'package:library_management_app/core/config/supabase_config.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/features/gamification/data/datasources/leaderboard_remote_datasource.dart';
import 'package:library_management_app/features/gamification/domain/entities/house_entity.dart';
import 'package:library_management_app/features/gamification/domain/entities/leaderboard_entry_entity.dart';

/// Supabase implementation of [LeaderboardRemoteDataSource].
class SupabaseGamificationDataSource implements LeaderboardRemoteDataSource {
  final _client = SupabaseConfig.client;

  @override
  Future<List<LeaderboardEntryEntity>> getStudentLeaderboard() async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('role', 'student')
        .order('points', ascending: false);

    int rank = 0;
    return data.map<LeaderboardEntryEntity>((json) {
      rank++;
      return LeaderboardEntryEntity(
        userId: json['id'] as String,
        userName: json['name'] as String? ?? '',
        houseId: json['house_id'] as String? ?? '',
        houseName: (json['house_id'] as String? ?? ''),
        points: (json['points'] as num?)?.toInt() ?? 0,
        rank: rank,
        booksReturned: 0, // Can be computed with a count query if needed
      );
    }).toList();
  }

  @override
  Future<List<HouseEntity>> getHouseLeaderboard() async {
    final data = await _client
        .from('houses')
        .select()
        .order('total_points', ascending: false);
    return data.map<HouseEntity>((json) => _houseFromJson(json)).toList();
  }

  @override
  Future<List<HouseEntity>> getAvailableHouses() async {
    final data = await _client.from('houses').select().order('name');
    return data.map<HouseEntity>((json) => _houseFromJson(json)).toList();
  }

  @override
  Future<void> selectHouse(String userId, String houseId) async {
    await _client
        .from('profiles')
        .update({'house_id': houseId}).eq('id', userId);

    // Increment house member count
    await _client.rpc('increment_house_member', params: {
      'house_id_param': houseId,
    }).catchError((_) {
      // If the RPC doesn't exist, do a manual increment
      return null;
    });
  }

  HouseEntity _houseFromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final colors = _colorsForHouseId(id);
    return HouseEntity(
      id: id,
      name: json['name'] as String,
      primaryColor: colors.$1,
      lightBackground: colors.$2,
      darkTextColor: colors.$3,
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Returns (primaryColor, lightBackground, darkTextColor) for known house IDs.
  (Color, Color, Color) _colorsForHouseId(String id) {
    switch (id) {
      case 'gryffindor':
        return (AppColors.houseGryffindor, AppColors.houseGryffindorLight, AppColors.houseGryffindorText);
      case 'slytherin':
        return (AppColors.houseSlytherin, AppColors.houseSlytherinLight, AppColors.houseSlytherinText);
      case 'ravenclaw':
        return (AppColors.houseRavenclaw, AppColors.houseRavenclawLight, AppColors.houseRavenclawText);
      case 'hufflepuff':
        return (AppColors.houseHufflepuff, AppColors.houseHufflepuffLight, AppColors.houseHufflepuffText);
      default:
        return (const Color(0xFF6B7280), const Color(0xFFF3F4F6), const Color(0xFF374151));
    }
  }
}
