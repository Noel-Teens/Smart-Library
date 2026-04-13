import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/services/fcm_service.dart';
import 'package:library_management_app/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:library_management_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/domain/repositories/auth_repository.dart';

// ──────────────────────────────────────────────
// Repository Provider
// ──────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(SupabaseAuthDataSource());
});

// ──────────────────────────────────────────────
// Auth State Notifier
// ──────────────────────────────────────────────
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserEntity?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    // Attempt to restore an existing session.
    final repo = ref.read(authRepositoryProvider);
    return repo.getCurrentUser();
  }

  /// Signs in with Google OAuth.
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signInWithGoogle();
      // Store FCM token after successful sign-in
      unawaited(FcmService.instance.init().catchError((_) {}));
      return user;
    });
  }

  /// Signs in with email and password.
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signInWithPassword(
          email: email, password: password);
      unawaited(FcmService.instance.init().catchError((_) {}));
      return user;
    });
  }

  /// Signs up a new user with email and password.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signUp(
          email: email, password: password, name: name);
      unawaited(FcmService.instance.init().catchError((_) {}));
      return user;
    });
  }

  /// Signs the user out and resets state.
  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    state = const AsyncValue.data(null);
  }

  /// Updates the current user's house assignment (called from gamification).
  void updateHouse(String houseId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(houseId: houseId));
  }
}

// ──────────────────────────────────────────────
// Convenience Selectors
// ──────────────────────────────────────────────

/// Whether the user is currently authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).valueOrNull != null;
});

/// The current user's role (or `null` if not signed in).
final currentUserRoleProvider = Provider<UserRole?>((ref) {
  return ref.watch(authNotifierProvider).valueOrNull?.role;
});
