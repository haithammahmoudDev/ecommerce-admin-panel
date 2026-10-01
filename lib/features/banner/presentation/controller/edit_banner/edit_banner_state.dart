part of 'edit_banner_cubit.dart';

enum EditBannerStatus { initial, loading, error, success }

class EditBannerState extends Equatable {
  final bool isActive;
  final EditBannerStatus status;
  final String? errorMessage;
  final String imageUrl;
  final BannerTargetType targetType;
  final String targetId;
  final String targetName;

  const EditBannerState({
    this.errorMessage,
    this.status = EditBannerStatus.initial,
    this.imageUrl = '',
    this.isActive = true,
    this.targetType = BannerTargetType.none,
    this.targetId = '',
    this.targetName = '',
  });

  @override
  List<Object?> get props => [isActive, status, errorMessage, imageUrl, targetType, targetId, targetName];

  EditBannerState copyWith({
    EditBannerStatus? status,
    String? errorMessage,
    String? imageUrl,
    bool? isActive,
    BannerTargetType? targetType,
    String? targetId,
    String? targetName,
    bool clearTarget = false,
  }) {
    return EditBannerState(
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