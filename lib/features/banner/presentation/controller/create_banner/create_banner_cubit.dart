import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/features/banner/domain/repos/banner_repo.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/controller/banner_cubit.dart';
import 'package:ecommerce_admin_pannal/features/media/domain/entities/image_entity.dart';
import 'package:ecommerce_admin_pannal/features/media/presentation/controller/media_cubit/media_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/constants/app_screens.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../media/data/models/image_model.dart';
import '../../../data/models/banner_model.dart';

part 'create_banner_state.dart';

class CreateBannerCubit extends Cubit<CreateBannerState> {
  final BannerRepo _bannerRepo;
  CreateBannerCubit({required this._bannerRepo}) : super(CreateBannerState());

  void toggleActive(bool? value) {
    emit(state.copyWith(isActive: value ?? false));
  }

  void selectTargetScreen(String? value) {
    emit(state.copyWith(targetScreen: value));
  }

  void pickImage(BuildContext context) async {
    final controller = context.read<MediaCubit>();
    List<ImageEntity>? selectedImages = await controller.selectImagesFromMedia(context: context);

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageEntity selectedImage = selectedImages.first;
      emit(state.copyWith(imageUrl: selectedImage.url));
     }
  }

  Future<void> createBanner(BuildContext context) async{
    TFullScreenLoader.popUpCircular(context);

    // Check Internet Connectivity
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading(context);
      return;
    }

    // Map Data
    final newRecord = BannerModel(
        id: '',
        imageUrl: state.imageUrl,
        active: state.isActive,
        targetScreen: state.targetScreen,
    );

    final result = await _bannerRepo.createBanner(newRecord);
    result.fold((error){
      TFullScreenLoader.stopLoading(context);
      TLoaders.errorSnackBar(title: 'Oh Snap', message: error.message, context: context);
    }, (bannerId){
      newRecord.id = bannerId;
      final bannerController = context.read<BannerCubit>();
      bannerController.addItemToLists(newRecord.toEntity());
      TFullScreenLoader.stopLoading(context);
      TLoaders.successSnackBar(title: 'Congratulations', message: 'New Record has been added.', context: context);
      bannerController.fetchData();
      context.pop();
    });
  }
}
