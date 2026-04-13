import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/gamification/presentation/providers/leaderboard_provider.dart';
import 'package:library_management_app/features/gamification/presentation/widgets/house_card.dart';
import 'package:library_management_app/features/gamification/presentation/widgets/leaderboard_tile.dart';

/// Leaderboard screen with Individual / Houses tab bar.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Students'),
              Tab(text: 'Houses'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _StudentsTab(),
            _HousesTab(),
          ],
        ),
      ),
    );
  }
}

class _StudentsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(studentLeaderboardProvider);
    final currentUserId =
        ref.watch(authNotifierProvider).valueOrNull?.id;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(studentLeaderboardProvider);
      },
      child: leaderboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorStateWidget(
          error: e,
          onRetry: () => ref.invalidate(studentLeaderboardProvider),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  child: const Center(child: Text('No leaderboard data yet')),
                ),
              ],
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return LeaderboardTile(
                entry: entry,
                isCurrentUser: entry.userId == currentUserId,
              );
            },
          );
        },
      ),
    );
  }
}

class _HousesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final housesAsync = ref.watch(houseLeaderboardProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(houseLeaderboardProvider);
      },
      child: housesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorStateWidget(
          error: e,
          onRetry: () => ref.invalidate(houseLeaderboardProvider),
        ),
        data: (houses) {
          if (houses.isEmpty) {
            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  child: const Center(child: Text('No house data yet')),
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: houses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final house = houses[index];
              return HouseCard(house: house, rank: index + 1);
            },
          );
        },
      ),
    );
  }
}
