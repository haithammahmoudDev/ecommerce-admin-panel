import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/features/banner/domain/repos/banner_repo.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/controller/banner_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/constants/app_screens.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../brand/domain/entities/brand_entity.dart';
import '../../../../media/data/models/image_model.dart';
import '../../../../media/presentation/controller/media_cubit/media_cubit.dart';
import '../../../data/models/banner_model.dart';
import '../../../domain/entities/banner_entity.dart';

part 'edit_banner_state.dart';

class EditBannerCubit extends Cubit<EditBannerState> {
  final BannerRepo _bannerRepo;
  EditBannerCubit({required this._bannerRepo}) : super(EditBannerState());

  void init(BannerEntity banner) {
    emit(state.copyWith(
      imageUrl: banner.imageUrl,
      isActive: banner.active,
      targetScreen: banner.targetScreen,
    ));
  }

  void toggleActive(bool? value) {
    emit(state.copyWith(isActive: value ?? false));
  }

  void selectTargetScreen(String? value) {
    emit(state.copyWith(targetScreen: value));
  }

  Future<void> editCategory({
    required BuildContext context,
    required String id,
  }) async {
    TFullScreenLoader.popUpCircular(context);

    final bool isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading(context);
      return;
    }

    final BannerModel newRecord = BannerModel(
      id: id,
      imageUrl: state.imageUrl,
      active: state.isActive ?? false,
      targetScreen: state.targetScreen,

    );

    final result = await _bannerRepo.editBanner(newRecord);

    result.fold(
          (error) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(title: 'Oh Snap', message: error.message, context: context);
      },
          (_) {
        final bannerController = context.read<BannerCubit>();

        bannerController.updateItemInLists(newRecord.toEntity());

        TFullScreenLoader.stopLoading(context);
        TLoaders.successSnackBar(title: 'Congratulations', message: 'Record updated successfully.', context: context);
        context.pop();
      },
    );
  }
  /// Pick Thumbnail Image from Media
  Future<void> pickImage(BuildContext context) async {
    final controller = context.read<MediaCubit>();// لسه GetX هنا، الـ MediaController مستقل عن الفورم
    final selectedImages = await controller.selectImagesFromMedia(context: context);

    if (selectedImages != null && selectedImages.isNotEmpty) {
      final ImageModel selectedImage = selectedImages.first;
      emit(state.copyWith(imageUrl: selectedImage.url));
    }
  }
}
