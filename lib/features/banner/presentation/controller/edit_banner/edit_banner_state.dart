part of 'edit_banner_cubit.dart';

enum EditBannerStatus { initial, loading, error, success }

class EditBannerState extends Equatable {
  final bool? isActive;
  final EditBannerStatus status;
  final String? errorMessage;
  final String imageUrl;
  final String targetScreen;

   const EditBannerState({
    this.errorMessage,
    this.status = EditBannerStatus.initial,
    this.imageUrl = '',
    this.isActive = false,
    this.targetScreen = AppScreens.onboarding,
  });

  @override
  List<Object?> get props => [isActive, status, errorMessage, imageUrl, targetScreen];

  EditBannerState copyWith({
    EditBannerStatus? status,
    String? errorMessage,
    String? imageUrl,
    bool? isActive,
   String? targetScreen,
  }) {
    return EditBannerState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
        targetScreen: targetScreen ?? this.targetScreen,
    );
  }
}

