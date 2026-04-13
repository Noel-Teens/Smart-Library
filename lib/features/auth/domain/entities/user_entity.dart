import 'package:equatable/equatable.dart';

/// The four roles defined in PRD §3.
enum UserRole {
  student,
  librarian,
  admin,
  staff;

  /// Display label (e.g. 'Student', 'Librarian').
  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.librarian:
        return 'Librarian';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.staff:
        return 'Staff';
    }
  }
}

/// Domain entity representing an authenticated user.
///
/// This entity is framework-agnostic — it contains no Flutter or
/// Supabase dependencies. Serialisation lives in [UserModel].
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.houseId,
    this.points = 0,
    this.isFrozen = false,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final UserRole role;

  /// The house this user belongs to (nullable until onboarding completes).
  final String? houseId;

  /// Cumulative gamification points.
  final int points;

  /// Whether the account is frozen due to unpaid fines (BRD BBR-04).
  final bool isFrozen;

  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatarUrl,
        role,
        houseId,
        points,
        isFrozen,
        createdAt,
      ];

  /// Returns a copy with overridden fields.
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    UserRole? role,
    String? houseId,
    int? points,
    bool? isFrozen,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      houseId: houseId ?? this.houseId,
      points: points ?? this.points,
      isFrozen: isFrozen ?? this.isFrozen,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
