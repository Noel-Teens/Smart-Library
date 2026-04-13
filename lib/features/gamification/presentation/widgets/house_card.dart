import 'package:flutter/material.dart';
import 'package:library_management_app/features/gamification/domain/entities/house_entity.dart';

/// Card showing a house with its colour, points, and member count.
class HouseCard extends StatelessWidget {
  const HouseCard({
    super.key,
    required this.house,
    this.rank,
    this.isSelected = false,
    this.onTap,
  });

  final HouseEntity house;
  final int? rank;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: house.lightBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? house.primaryColor : house.primaryColor.withValues(alpha: 0.3),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: house.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: house.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    house.name[0],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        house.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: house.darkTextColor,
                        ),
                      ),
                      if (house.memberCount > 0)
                        Text(
                          '${house.memberCount} members',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: house.darkTextColor.withValues(alpha: 0.7),
                          ),
                        ),
                    ],
                  ),
                ),
                if (rank != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: house.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#$rank',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: house.primaryColor,
                      ),
                    ),
                  ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: house.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                  ),
              ],
            ),
            if (house.totalPoints > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.star_rounded,
                      size: 16, color: house.primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    '${house.totalPoints} pts',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: house.darkTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
