import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../utils/helpers/network_manager.dart';
import '../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../media/domain/entities/image_entity.dart';
import '../../../../media/presentation/controller/media_cubit/media_cubit.dart';
import '../../../data/models/banner_model.dart';

import '../../../domain/entities/banner_entity.dart';
import '../../../domain/repos/banner_repo.dart';
import '../banner_cubit.dart';

part 'edit_banner_state.dart';

class EditBannerCubit extends Cubit<EditBannerState> {
  final BannerRepo _bannerRepo;
  EditBannerCubit({required this._bannerRepo}) : super(const EditBannerState());

  void init(BannerEntity banner) {
    emit(state.copyWith(
      imageUrl: banner.imageUrl,
      isActive: banner.active,
      targetType: banner.targetType,
      targetId: banner.targetId ?? '',
      targetName: banner.targetName ?? '',
    ));
  }

  void toggleActive(bool? value) {
    emit(state.copyWith(isActive: value ?? true));
  }

  void selectTargetType(BannerTargetType? type) {
    emit(state.copyWith(
      targetType: type ?? BannerTargetType.none,
      clearTarget: true,
    ));
  }

  void setTargetDetails(String id, String name) {
    emit(state.copyWith(targetId: id, targetName: name));
  }

  Future<void> editBanner({
    required BuildContext context,
    required String id,
  }) async {
    final tempEntity = BannerEntity(
      id: id,
      imageUrl: state.imageUrl,
      active: state.isActive,
      targetType: state.targetType,
      targetId: state.targetId,
      targetName: state.targetName,
    );

    final validationError = tempEntity.validate();
    if (validationError != null) {
      TLoaders.errorSnackBar(title: 'Validation Error', message: validationError, context: context);
      return;
    }

    TFullScreenLoader.popUpCircular(context);

    final bool isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading(context);
      TLoaders.errorSnackBar(title: 'Network Error', message: 'No internet connection.', context: context);
      return;
    }

    final updatedRecord = BannerModel.fromEntity(tempEntity);

    final result = await _bannerRepo.editBanner(updatedRecord);

    result.fold(
          (error) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(title: 'Oh Snap', message: error.message, context: context);
      },
          (_) {
        final bannerController = context.read<BannerCubit>();
        bannerController.updateItemInLists(updatedRecord.toEntity());

        TFullScreenLoader.stopLoading(context);
        TLoaders.successSnackBar(title: 'Congratulations', message: 'Record updated successfully.', context: context);
        context.pop();
      },
    );
  }

  Future<void> pickImage(BuildContext context) async {
    final controller = context.read<MediaCubit>();
    final selectedImages = await controller.selectImagesFromMedia(context: context);

    if (selectedImages != null && selectedImages.isNotEmpty) {
      final ImageEntity selectedImage = selectedImages.first;
      emit(state.copyWith(imageUrl: selectedImage.url));
    }
  }
}

