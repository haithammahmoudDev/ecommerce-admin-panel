part of 'settings_cubit.dart';

enum SettingsStatus { initial, loaded, error, success }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final SettingsEntity settings;
  final bool isFormLoading;
  final bool isLogoLoading;
  final String? errorMessage;
  final String? successMessage;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.settings = const SettingsEntity(),
    this.isFormLoading = false,
    this.isLogoLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    SettingsEntity? settings,
    bool? isFormLoading,
    bool? isLogoLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      isFormLoading: isFormLoading ?? this.isFormLoading,
      isLogoLoading: isLogoLoading ?? this.isLogoLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    settings,
    isFormLoading,
    isLogoLoading,
    errorMessage,
    successMessage,
  ];
}