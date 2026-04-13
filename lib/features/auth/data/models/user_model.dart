import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';

/// Data-layer model for [UserEntity] with JSON serialisation.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.avatarUrl,
    super.houseId,
    super.points,
    super.isFrozen,
    required super.createdAt,
  });

  /// Deserialise from a Supabase / JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.student,
      ),
      avatarUrl: json['avatar_url'] as String?,
      houseId: json['house_id'] as String?,
      points: (json['points'] as num?)?.toInt() ?? 0,
      isFrozen: json['is_frozen'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Serialise to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'avatar_url': avatarUrl,
      'house_id': houseId,
      'points': points,
      'is_frozen': isFrozen,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convert a domain entity to a model.
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      role: entity.role,
      avatarUrl: entity.avatarUrl,
      houseId: entity.houseId,
      points: entity.points,
      isFrozen: entity.isFrozen,
      createdAt: entity.createdAt,
    );
  }
}
