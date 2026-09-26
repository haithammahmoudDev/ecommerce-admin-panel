part of 'create_banner_cubit.dart';


enum CreateBannerStatus { initial, loading, error, success }

class CreateBannerState extends Equatable {
  final bool isActive;
  final CreateBannerStatus status;
  final String? errorMessage;
  final String imageUrl;
  final String targetScreen;

  CreateBannerState({
    this.errorMessage,
    this.status = CreateBannerStatus.initial,
    this.imageUrl = '',
    this.isActive = false,
    this.targetScreen = AppScreens.onboarding,
   });

  @override
  List<Object?> get props => [isActive, status, errorMessage, imageUrl, targetScreen];

  CreateBannerState copyWith({
    CreateBannerStatus? status,
    String? errorMessage,
     String? imageUrl,
    bool? isActive,
    String? targetScreen
  }) {
    return CreateBannerState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
       imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
        targetScreen : targetScreen ?? this.targetScreen
    );
  }
}
