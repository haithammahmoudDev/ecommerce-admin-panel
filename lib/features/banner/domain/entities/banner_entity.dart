import '../../../../utils/constants/enums.dart';

class BannerEntity {
  final String id;
  final String imageUrl;
  final bool active;
  final BannerTargetType targetType;
  final String? targetId;
  final String? targetName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BannerEntity({
    this.id = '',
    required this.imageUrl,
    this.active = true,
    this.targetType = BannerTargetType.none,
    this.targetId,
    this.targetName,
    this.createdAt,
    this.updatedAt,
  });

  BannerEntity copyWith({
    String? id,
    String? imageUrl,
    bool? active,
    BannerTargetType? targetType,
    String? targetId,
    String? targetName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearTarget = false,
  }) {
    return BannerEntity(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      active: active ?? this.active,
      targetType: targetType ?? this.targetType,
      targetId: clearTarget ? null : (targetId ?? this.targetId),
      targetName: clearTarget ? null : (targetName ?? this.targetName),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String? validate() {
    if (imageUrl.trim().isEmpty) return 'Please select a banner image.';

    if (targetType.requiresTarget &&
        (targetId == null || targetId!.trim().isEmpty)) {
      return 'Please choose a destination for this banner.';
    }

    if (targetType == BannerTargetType.external &&
        !targetId!.trim().startsWith('https://')) {
      return 'External link must start with https://';
    }

    return null;
  }
}