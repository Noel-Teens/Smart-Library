import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/constants/route_constants.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';

/// Provides GoRouter redirect logic for authentication and role guards.
///
/// • Unauthenticated users are sent to [RouteConstants.login].
/// • Authenticated users are redirected away from /login to their role home.
/// • Role-inappropriate routes are blocked with a redirect.
class RouteGuards {
  const RouteGuards(this._ref);

  final Ref _ref;

  /// Master redirect function passed to GoRouter.
  String? redirect(BuildContext context, String location) {
    final authState = _ref.read(authNotifierProvider);
    final user = authState.valueOrNull;
    final isLoggedIn = user != null;
    final isOnLogin = location == RouteConstants.login;

    // ── Not authenticated ──
    if (!isLoggedIn) {
      return isOnLogin ? null : RouteConstants.login;
    }

    // ── Authenticated but on login page → redirect to home ──
    if (isOnLogin) {
      return RouteConstants.homeForRole(user.role.name);
    }

    // ── Role-based route protection ──
    if (location.startsWith('/student') && user.role != UserRole.student) {
      return RouteConstants.homeForRole(user.role.name);
    }
    if (location.startsWith('/librarian') && user.role != UserRole.librarian) {
      return RouteConstants.homeForRole(user.role.name);
    }
    if (location.startsWith('/admin') && user.role != UserRole.admin) {
      return RouteConstants.homeForRole(user.role.name);
    }
    if (location.startsWith('/staff') && user.role != UserRole.staff) {
      return RouteConstants.homeForRole(user.role.name);
    }

    return null; // No redirect — allow navigation.
  }
}
