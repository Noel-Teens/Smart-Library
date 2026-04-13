/// Named route path strings used with GoRouter.
abstract final class RouteConstants {
  // ──── Auth ────
  static const String login = '/login';
  static const String houseSelection = '/house-selection';

  // ──── Student ────
  static const String studentHome = '/student/home';
  static const String studentBooks = '/student/books';
  static const String studentBookDetail = '/student/books/:bookId';
  static const String studentBorrows = '/student/borrows';
  static const String studentLeaderboard = '/student/leaderboard';
  static const String studentProfile = '/student/profile';
  static const String studentNotifications = '/student/notifications';

  // ──── Librarian ────
  static const String librarianHome = '/librarian/home';
  static const String librarianBooks = '/librarian/books';
  static const String librarianBookDetail = '/librarian/books/:bookId';
  static const String librarianRequests = '/librarian/requests';
  static const String librarianFines = '/librarian/fines';
  static const String librarianProfile = '/librarian/profile';
  static const String librarianNotifications = '/librarian/notifications';

  // ──── Admin ────
  static const String adminHome = '/admin/home';
  static const String adminUsers = '/admin/users';
  static const String adminAudit = '/admin/audit';
  static const String adminBooks = '/admin/books';
  static const String adminBookDetail = '/admin/books/:bookId';
  static const String adminProfile = '/admin/profile';
  static const String adminNotifications = '/admin/notifications';

  // ──── Staff ────
  static const String staffHome = '/staff/home';
  static const String staffBooks = '/staff/books';
  static const String staffBookDetail = '/staff/books/:bookId';
  static const String staffProfile = '/staff/profile';

  /// Returns the role-appropriate home path.
  static String homeForRole(String role) {
    switch (role) {
      case 'librarian':
        return librarianHome;
      case 'admin':
        return adminHome;
      case 'staff':
        return staffHome;
      case 'student':
      default:
        return studentHome;
    }
  }
}
