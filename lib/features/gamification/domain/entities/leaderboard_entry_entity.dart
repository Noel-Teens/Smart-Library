import 'package:equatable/equatable.dart';

/// A single row on the student leaderboard.
class LeaderboardEntryEntity extends Equatable {
  const LeaderboardEntryEntity({
    required this.userId,
    required this.userName,
    this.houseId,
    this.houseName,
    required this.points,
    required this.rank,
    this.booksReturned = 0,
  });

  final String userId;
  final String userName;
  final String? houseId;
  final String? houseName;
  final int points;
  final int rank;
  final int booksReturned;

  @override
  List<Object?> get props => [userId, points, rank];
}
