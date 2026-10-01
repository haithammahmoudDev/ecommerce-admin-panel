

import '../../../../utils/constants/enums.dart';
import '../../domain/entities/banner_entity.dart';

class BannerModel {
  String id;
  final String imageUrl;
  final bool active;
  final BannerTargetType targetType;
  final String? targetId;
  final String? targetName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.active,
    required this.targetType,
    this.targetId,
    this.targetName,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'active': active,
      'targetType': targetType.name,
      'targetId': targetId,
      'targetName': targetName,
      'createdAt': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory BannerModel.fromFirebaseData(Map<String, dynamic> json, String id) {
    return BannerModel(
      id: id,
      imageUrl: json['imageUrl'] ?? '',
      active: json['active'] ?? true,
      targetType: BannerTargetType.values.firstWhere(
            (e) => e.name == json['targetType'],
        orElse: () => BannerTargetType.none,
      ),
      targetId: json['targetId'],
      targetName: json['targetName'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  BannerEntity toEntity() {
    return BannerEntity(
      id: id,
      imageUrl: imageUrl,
      active: active,
      targetType: targetType,
      targetId: targetId,
      targetName: targetName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory BannerModel.fromEntity(BannerEntity entity) {
    return BannerModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      active: entity.active,
      targetType: entity.targetType,
      targetId: entity.targetId,
      targetName: entity.targetName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}