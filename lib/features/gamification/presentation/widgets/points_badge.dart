import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';

/// Small points display badge with star icon.
class PointsBadge extends StatelessWidget {
  const PointsBadge({super.key, required this.points, this.large = false});

  final int points;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 14 : 10,
        vertical: large ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.pointsGoldBg,
        borderRadius: BorderRadius.circular(large ? 12 : 8),
        border: Border.all(
          color: AppColors.pointsGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: large ? 20 : 14,
            color: AppColors.pointsGold,
          ),
          const SizedBox(width: 4),
          Text(
            '$points pts',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: large ? 16 : 13,
              fontWeight: FontWeight.w700,
              color: AppColors.pointsGoldText,
            ),
          ),
        ],
      ),
    );
  }
}
