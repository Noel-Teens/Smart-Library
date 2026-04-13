import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';

/// Domain entity representing one of the four competition houses.
class HouseEntity extends Equatable {
  const HouseEntity({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.lightBackground,
    required this.darkTextColor,
    required this.totalPoints,
    required this.memberCount,
  });

  final String id;
  final String name;
  final Color primaryColor;
  final Color lightBackground;
  final Color darkTextColor;
  final int totalPoints;
  final int memberCount;

  @override
  List<Object?> get props => [id, name, totalPoints, memberCount];

  HouseEntity copyWith({
    String? id,
    String? name,
    Color? primaryColor,
    Color? lightBackground,
    Color? darkTextColor,
    int? totalPoints,
    int? memberCount,
  }) {
    return HouseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryColor: primaryColor ?? this.primaryColor,
      lightBackground: lightBackground ?? this.lightBackground,
      darkTextColor: darkTextColor ?? this.darkTextColor,
      totalPoints: totalPoints ?? this.totalPoints,
      memberCount: memberCount ?? this.memberCount,
    );
  }

  /// Returns the predefined house definitions (PRD §8.4).
  static const List<HouseEntity> allHouses = [
    HouseEntity(
      id: 'gryffindor',
      name: 'Gryffindor',
      primaryColor: AppColors.houseGryffindor,
      lightBackground: AppColors.houseGryffindorLight,
      darkTextColor: AppColors.houseGryffindorText,
      totalPoints: 0,
      memberCount: 0,
    ),
    HouseEntity(
      id: 'slytherin',
      name: 'Slytherin',
      primaryColor: AppColors.houseSlytherin,
      lightBackground: AppColors.houseSlytherinLight,
      darkTextColor: AppColors.houseSlytherinText,
      totalPoints: 0,
      memberCount: 0,
    ),
    HouseEntity(
      id: 'ravenclaw',
      name: 'Ravenclaw',
      primaryColor: AppColors.houseRavenclaw,
      lightBackground: AppColors.houseRavenclawLight,
      darkTextColor: AppColors.houseRavenclawText,
      totalPoints: 0,
      memberCount: 0,
    ),
    HouseEntity(
      id: 'hufflepuff',
      name: 'Hufflepuff',
      primaryColor: AppColors.houseHufflepuff,
      lightBackground: AppColors.houseHufflepuffLight,
      darkTextColor: AppColors.houseHufflepuffText,
      totalPoints: 0,
      memberCount: 0,
    ),
  ];
}
