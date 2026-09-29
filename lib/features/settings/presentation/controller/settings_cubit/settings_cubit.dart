import 'package:ecommerce_admin_pannal/features/media/domain/entities/image_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../../media/presentation/controller/media_cubit/media_cubit.dart';
import '../../../domain/entities/settings_entity.dart';
import '../../../domain/repos/settings_repo.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo settingsRepository;
  final MediaCubit _mediaCubit;

  SettingsCubit(this.settingsRepository, {required this._mediaCubit})
      : super(const SettingsState());

  final formKey = GlobalKey<FormState>();
  final appNameController = TextEditingController();
  final taxController = TextEditingController();
  final shippingController = TextEditingController();
  final freeShippingThresholdController = TextEditingController();

  Future<SettingsEntity> fetchSettingDetails() async {
    emit(state.copyWith(isFormLoading: true));

    final result = await settingsRepository.getSettings();

    return result.fold(
          (failure) {
        emit(state.copyWith(
          status: SettingsStatus.error,
          isFormLoading: false,
          errorMessage: failure.message,
        ));
        return const SettingsEntity();
      },
          (settings) {
        appNameController.text = settings.appName;
        taxController.text = settings.taxRate.toString();
        shippingController.text = settings.shippingCost.toString();
        freeShippingThresholdController.text =
            settings.freeShippingThreshold?.toString() ?? '';

        emit(state.copyWith(
          status: SettingsStatus.loaded,
          isFormLoading: false,
          settings: settings,
        ));
        return settings;
      },
    );
  }

  Future<void> updateAppLogo(BuildContext context) async {
    List<ImageEntity>? selectedImages =
    await _mediaCubit.selectImagesFromMedia(context: context);

    if (selectedImages != null && selectedImages.isNotEmpty) {
      emit(state.copyWith(isLogoLoading: true));

     final ImageEntity selectedImage = selectedImages.first;

      final result = await settingsRepository.updateSingleField({
        'appLogo': selectedImage.url,
      });

      result.fold(
            (failure) {
          emit(state.copyWith(
            status: SettingsStatus.error,
            isLogoLoading: false,
            errorMessage: failure.message,
          ));
        },
            (_) {
          final updatedSettings = state.settings.copyWith(
            appLogo: selectedImage.url,
          );

          emit(state.copyWith(
            status: SettingsStatus.success,
            isLogoLoading: false,
            settings: updatedSettings,
            successMessage: 'App Logo has been updated.',
          ));
        },
      );
    }
  }

  Future<void> updateSettingInformation() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'No internet connection. Please check your network.',
      ));
      return;
    }

    if (!formKey.currentState!.validate()) return;

    emit(state.copyWith(isFormLoading: true));

    final updatedSettings = state.settings.copyWith(
      appName: appNameController.text.trim(),
      taxRate: double.tryParse(taxController.text.trim()) ?? 0.0,
      shippingCost: double.tryParse(shippingController.text.trim()) ?? 0.0,
      freeShippingThreshold:
      double.tryParse(freeShippingThresholdController.text.trim()) ?? 0.0,
    );

    final result = await settingsRepository.updateSettingDetails(updatedSettings);

    result.fold(
          (failure) {
        emit(state.copyWith(
          status: SettingsStatus.error,
          isFormLoading: false,
          errorMessage: failure.message,
        ));
      },
          (_) {
        emit(state.copyWith(
          status: SettingsStatus.success,
          isFormLoading: false,
          settings: updatedSettings,
          successMessage: 'App Settings has been updated.',
        ));
      },
    );
  }

  @override
  Future<void> close() {
    appNameController.dispose();
    taxController.dispose();
    shippingController.dispose();
    freeShippingThresholdController.dispose();
    return super.close();
  }
}