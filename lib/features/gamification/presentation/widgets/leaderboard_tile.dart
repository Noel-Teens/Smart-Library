import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/features/gamification/domain/entities/leaderboard_entry_entity.dart';

/// A single row on the leaderboard list.
class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({
    super.key,
    required this.entry,
    this.isCurrentUser = false,
  });

  final LeaderboardEntryEntity entry;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.primary50
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.primary400
              : Theme.of(context).dividerColor,
          width: isCurrentUser ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 32,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: entry.rank <= 3 ? 18 : 14,
                fontWeight: FontWeight.w700,
                color: _rankColor(entry.rank),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Medal for top 3
          if (entry.rank <= 3)
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _rankColor(entry.rank).withValues(alpha: 0.15),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.emoji_events_rounded,
                size: 16,
                color: _rankColor(entry.rank),
              ),
            )
          else
            const SizedBox(width: 28),
          const SizedBox(width: 10),

          // Name + house
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.userName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (entry.houseName != null)
                  Text(
                    entry.houseName!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),

          // Points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.pointsGoldBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded,
                    size: 14, color: AppColors.pointsGold),
                const SizedBox(width: 4),
                Text(
                  '${entry.points}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pointsGoldText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.pointsGold;
      case 2:
        return AppColors.pointsSilver;
      case 3:
        return AppColors.pointsBronze;
      default:
        return AppColors.neutral500;
    }
  }
}
