import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/utils/error_handler.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/gamification/presentation/providers/leaderboard_provider.dart';
import 'package:library_management_app/features/gamification/presentation/widgets/house_card.dart';

/// House selection screen shown on first login when houseId is null.
class HouseSelectionScreen extends ConsumerStatefulWidget {
  const HouseSelectionScreen({super.key});

  @override
  ConsumerState<HouseSelectionScreen> createState() =>
      _HouseSelectionScreenState();
}

class _HouseSelectionScreenState extends ConsumerState<HouseSelectionScreen> {
  String? _selectedHouseId;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final housesAsync = ref.watch(availableHousesProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary900, AppColors.primary700],
          ),
        ),
        child: SafeArea(
          child: housesAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator(color: Colors.white)),
            error: (e, _) => ErrorStateWidget(
              error: e,
              onRetry: () => ref.invalidate(availableHousesProvider),
            ),
            data: (houses) {
              return Column(
                children: [
                  const SizedBox(height: 32),
                  const Icon(Icons.shield_rounded,
                      size: 56, color: Colors.white70),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose Your House',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This choice is permanent for the academic year',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: houses.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final house = houses[index];
                        return HouseCard(
                          house: house,
                          isSelected: _selectedHouseId == house.id,
                          onTap: () => setState(
                              () => _selectedHouseId = house.id),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            _selectedHouseId != null && !_isSubmitting
                                ? _onConfirm
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary700,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5),
                              )
                            : const Text(
                                'Join This House',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onConfirm() async {
    if (_selectedHouseId == null) return;
    setState(() => _isSubmitting = true);

    try {
      await selectHouseAction(ref, _selectedHouseId!);
      if (mounted) {
        context.go('/student/books');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        showErrorSnackBar(context, e);
      }
    }
  }
}
