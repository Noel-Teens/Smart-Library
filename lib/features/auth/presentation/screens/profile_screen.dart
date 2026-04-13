import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/fines/presentation/providers/fines_provider.dart';
import 'package:library_management_app/features/gamification/domain/entities/house_entity.dart';
import 'package:library_management_app/features/gamification/presentation/widgets/points_badge.dart';

/// Profile screen shared by student and librarian shells.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not signed in')),
      );
    }

    final totalFines = ref.watch(totalOutstandingAmountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Avatar ──
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primary100,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Name ──
            Text(
              user.name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 8),

            // ── Role badge ──
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary200),
              ),
              child: Text(
                user.role.label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary600,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Stats cards ──
            if (user.role == UserRole.student) ...[
              // Points
              PointsBadge(points: user.points, large: true),
              const SizedBox(height: 16),

              // House
              if (user.houseId != null)
                _buildHouseCard(user.houseId!),
              const SizedBox(height: 16),

              // Fines status
              if (totalFines > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.error100),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.error500),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Outstanding Fines',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppColors.error700,
                              ),
                            ),
                            Text(
                              '₹$totalFines',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.success100),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: AppColors.success500),
                      SizedBox(width: 12),
                      Text(
                        'No outstanding fines',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.success700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],

            const SizedBox(height: 32),

            // ── Account info ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow('User ID', user.id),
                    const Divider(height: 24),
                    _infoRow('Member since',
                        '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'),
                    const Divider(height: 24),
                    _infoRow('Account status',
                        user.isFrozen ? 'Frozen' : 'Active'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Sign out ──
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).signOut();
                },
                icon: const Icon(Icons.logout, color: AppColors.error500),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(color: AppColors.error500),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error100),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseCard(String houseId) {
    final house = HouseEntity.allHouses.firstWhere(
      (h) => h.id == houseId,
      orElse: () => HouseEntity.allHouses.first,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: house.lightBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: house.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
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
                  'House ${house.name}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: house.darkTextColor,
                  ),
                ),
                Text(
                  'Member',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: house.darkTextColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
