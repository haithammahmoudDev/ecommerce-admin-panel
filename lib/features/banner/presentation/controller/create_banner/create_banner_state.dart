part of 'create_banner_cubit.dart';

enum CreateBannerStatus { initial, loading, error, success }

class CreateBannerState extends Equatable {
  final bool isActive;
  final CreateBannerStatus status;
  final String? errorMessage;
  final String imageUrl;
  final BannerTargetType targetType;
  final String targetId;
  final String targetName;

  const CreateBannerState({
    this.errorMessage,
    this.status = CreateBannerStatus.initial,
    this.imageUrl = '',
    this.isActive = true,
    this.targetType = BannerTargetType.none,
    this.targetId = '',
    this.targetName = '',
  });

  @override
  List<Object?> get props => [isActive, status, errorMessage, imageUrl, targetType, targetId, targetName];

  CreateBannerState copyWith({
    CreateBannerStatus? status,
    String? errorMessage,
    String? imageUrl,
    bool? isActive,
    BannerTargetType? targetType,
    String? targetId,
    String? targetName,
    bool clearTarget = false,
  }) {
    return CreateBannerState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      targetType: targetType ?? this.targetType,
      targetId: clearTarget ? '' : (targetId ?? this.targetId),
      targetName: clearTarget ? '' : (targetName ?? this.targetName),
    );
  }
}