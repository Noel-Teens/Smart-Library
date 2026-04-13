import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:library_management_app/core/constants/route_constants.dart';
import 'package:library_management_app/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:library_management_app/features/admin/presentation/screens/audit_log_screen.dart';
import 'package:library_management_app/features/admin/presentation/screens/user_management_screen.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/auth/presentation/screens/login_screen.dart';
import 'package:library_management_app/features/auth/presentation/screens/profile_screen.dart';
import 'package:library_management_app/features/auth/presentation/screens/staff_dashboard_screen.dart';
import 'package:library_management_app/features/auth/presentation/screens/student_dashboard_screen.dart';
import 'package:library_management_app/features/books/presentation/screens/book_catalogue_screen.dart';
import 'package:library_management_app/features/books/presentation/screens/book_detail_screen.dart';
import 'package:library_management_app/features/fines/presentation/screens/fines_screen.dart';
import 'package:library_management_app/features/gamification/presentation/screens/house_selection_screen.dart';
import 'package:library_management_app/features/gamification/presentation/screens/leaderboard_screen.dart';
import 'package:library_management_app/features/librarian/presentation/screens/librarian_dashboard_screen.dart';
import 'package:library_management_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:library_management_app/features/transactions/presentation/screens/my_borrows_screen.dart';
import 'package:library_management_app/features/transactions/presentation/screens/request_queue_screen.dart';
import 'package:library_management_app/routing/admin_shell.dart';
import 'package:library_management_app/routing/librarian_shell.dart';
import 'package:library_management_app/routing/staff_shell.dart';
import 'package:library_management_app/routing/student_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.login,
    debugLogDiagnostics: true,
    refreshListenable: _RefreshNotifier(ref),
    redirect: (context, state) {
      // Read (not watch) auth state inside the redirect so the GoRouter
      // instance is created only once and screens are not remounted.
      final user = ref.read(authNotifierProvider).valueOrNull;
      final isLoggedIn = user != null;
      final location = state.uri.toString();
      final isOnLogin = location == RouteConstants.login;
      final isOnHouseSelection =
          location == RouteConstants.houseSelection;

      // Not authenticated → must be on login
      if (!isLoggedIn) {
        return isOnLogin ? null : RouteConstants.login;
      }

      // Authenticated but on login → go to role home
      if (isOnLogin) {
        // Student without house → onboarding first
        if (user.role == UserRole.student && user.houseId == null) {
          return RouteConstants.houseSelection;
        }
        return RouteConstants.homeForRole(user.role.name);
      }

      // Student on house-selection without a house → allow
      if (isOnHouseSelection &&
          user.role == UserRole.student &&
          user.houseId == null) {
        return null;
      }
      // Student on house-selection WITH a house → skip to home
      if (isOnHouseSelection && user.houseId != null) {
        return RouteConstants.homeForRole(user.role.name);
      }

      // Role-based protection
      if (location.startsWith('/student') &&
          user.role != UserRole.student) {
        return RouteConstants.homeForRole(user.role.name);
      }
      if (location.startsWith('/librarian') &&
          user.role != UserRole.librarian) {
        return RouteConstants.homeForRole(user.role.name);
      }
      if (location.startsWith('/admin') &&
          user.role != UserRole.admin) {
        return RouteConstants.homeForRole(user.role.name);
      }
      if (location.startsWith('/staff') &&
          user.role != UserRole.staff) {
        return RouteConstants.homeForRole(user.role.name);
      }

      return null;
    },
    routes: [
      // ── Login ──
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // ── House Selection (one-time onboarding) ──
      GoRoute(
        path: RouteConstants.houseSelection,
        builder: (context, state) => const HouseSelectionScreen(),
      ),

      // ══════════════════════════════════════════════
      // ██ STUDENT SHELL (5 tabs)
      // ══════════════════════════════════════════════
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            StudentShell(navigationShell: navigationShell),
        branches: [
          // Tab 0: Home
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/student/home',
              builder: (context, state) =>
                  const StudentDashboardScreen(),
            ),
          ]),
          // Tab 1: Books
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/student/books',
              builder: (context, state) =>
                  const BookCatalogueScreen(),
              routes: [
                GoRoute(
                  path: ':bookId',
                  builder: (context, state) => BookDetailScreen(
                    bookId: state.pathParameters['bookId']!,
                  ),
                ),
              ],
            ),
          ]),
          // Tab 2: My Borrows
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/student/borrows',
              builder: (context, state) =>
                  const MyBorrowsScreen(),
            ),
          ]),
          // Tab 3: Leaderboard
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/student/leaderboard',
              builder: (context, state) =>
                  const LeaderboardScreen(),
            ),
          ]),
          // Tab 4: Profile
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/student/profile',
              builder: (context, state) =>
                  const ProfileScreen(),
            ),
          ]),
        ],
      ),

      // Student notifications (pushed on top of shell)
      GoRoute(
        path: '/student/notifications',
        builder: (context, state) =>
            const NotificationsScreen(),
      ),

      // ══════════════════════════════════════════════
      // ██ LIBRARIAN SHELL (5 tabs)
      // ══════════════════════════════════════════════
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LibrarianShell(navigationShell: navigationShell),
        branches: [
          // Tab 0: Home
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/librarian/home',
              builder: (context, state) =>
                  const LibrarianDashboardScreen(),
            ),
          ]),
          // Tab 1: Books
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/librarian/books',
              builder: (context, state) =>
                  const BookCatalogueScreen(),
              routes: [
                GoRoute(
                  path: ':bookId',
                  builder: (context, state) => BookDetailScreen(
                    bookId: state.pathParameters['bookId']!,
                  ),
                ),
              ],
            ),
          ]),
          // Tab 2: Requests
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/librarian/requests',
              builder: (context, state) =>
                  const RequestQueueScreen(),
            ),
          ]),
          // Tab 3: Fines
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/librarian/fines',
              builder: (context, state) => const FinesScreen(),
            ),
          ]),
          // Tab 4: Profile
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/librarian/profile',
              builder: (context, state) =>
                  const ProfileScreen(),
            ),
          ]),
        ],
      ),

      // Librarian notifications
      GoRoute(
        path: '/librarian/notifications',
        builder: (context, state) =>
            const NotificationsScreen(),
      ),

      // ══════════════════════════════════════════════
      // ██ ADMIN SHELL (4 tabs)
      // ══════════════════════════════════════════════
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdminShell(navigationShell: navigationShell),
        branches: [
          // Tab 0: Home
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/home',
              builder: (context, state) =>
                  const AdminDashboardScreen(),
            ),
          ]),
          // Tab 1: Users
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/users',
              builder: (context, state) =>
                  const UserManagementScreen(),
            ),
          ]),
          // Tab 2: Audit Log
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/audit',
              builder: (context, state) =>
                  const AuditLogScreen(),
            ),
          ]),
          // Tab 3: Profile
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/profile',
              builder: (context, state) =>
                  const ProfileScreen(),
            ),
          ]),
        ],
      ),

      // Admin extra routes (pushed on top of shell)
      GoRoute(
        path: '/admin/notifications',
        builder: (context, state) =>
            const NotificationsScreen(),
      ),
      GoRoute(
        path: '/admin/books',
        builder: (context, state) =>
            const BookCatalogueScreen(),
        routes: [
          GoRoute(
            path: ':bookId',
            builder: (context, state) => BookDetailScreen(
              bookId: state.pathParameters['bookId']!,
            ),
          ),
        ],
      ),

      // ══════════════════════════════════════════════
      // ██ STAFF SHELL (3 tabs)
      // ══════════════════════════════════════════════
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            StaffShell(navigationShell: navigationShell),
        branches: [
          // Tab 0: Home
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/staff/home',
              builder: (context, state) =>
                  const StaffDashboardScreen(),
            ),
          ]),
          // Tab 1: Books (read-only)
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/staff/books',
              builder: (context, state) =>
                  const BookCatalogueScreen(),
              routes: [
                GoRoute(
                  path: ':bookId',
                  builder: (context, state) => BookDetailScreen(
                    bookId: state.pathParameters['bookId']!,
                  ),
                ),
              ],
            ),
          ]),
          // Tab 2: Profile
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/staff/profile',
              builder: (context, state) =>
                  const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});

/// Converts [Ref] stream into a [Listenable] for GoRouter refresh.
class _RefreshNotifier extends ChangeNotifier {
  _RefreshNotifier(Ref ref) {
    ref.listen(authNotifierProvider, (prev, next) {
      notifyListeners();
    });
  }
}
