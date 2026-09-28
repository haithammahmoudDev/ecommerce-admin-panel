import 'package:ecommerce_admin_pannal/features/media/domain/entities/image_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_image/product_image_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../media/data/models/image_model.dart';
import '../../../../media/presentation/controller/media_cubit/media_cubit.dart';

class ProductImagesCubit extends Cubit<ProductImagesState> {
  ProductImagesCubit() : super(const ProductImagesState());

  List<String> get additionalProductImagesUrls => state.additionalProductImagesUrls;

  void selectThumbnailImage(BuildContext context) async {
    final mediaCubit = context.read<MediaCubit>();

    emit(state.copyWith(isLoading: true));

    try {
      List<ImageEntity>? selectedImages = await mediaCubit.selectImagesFromMedia(context: context);

      if (selectedImages != null && selectedImages.isNotEmpty) {
        ImageEntity selectedImage = selectedImages.first;
        emit(state.copyWith(
          selectedThumbnailImageUrl: selectedImage.url,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Pick Multiple Images from Media
  void selectMultipleProductImages(BuildContext context) async {
    final mediaCubit = context.read<MediaCubit>();

    emit(state.copyWith(isLoading: true));

    try {
      final selectedImages = await mediaCubit.selectImagesFromMedia(
        context: context,
        allowSelection: true,
        allowMultipleSelection: true,
        selectedUrls: state.additionalProductImagesUrls,
      );

      if (selectedImages != null && selectedImages.isNotEmpty) {
        final updatedUrls = selectedImages.map((e) => e.url).toList();

        emit(
          state.copyWith(
            additionalProductImagesUrls: updatedUrls,
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void setSelectedThumbnailImageUrl(String? url) {
    emit(state.copyWith(selectedThumbnailImageUrl: url));
  }

  void setAdditionalProductImagesUrls(List<String> urls) {
    emit(state.copyWith(additionalProductImagesUrls: urls));
  }

  /// Function to remove Product image
  Future<void> removeImage(int index) async {
    final updatedList = List<String>.from(state.additionalProductImagesUrls)
      ..removeAt(index);

    emit(state.copyWith(additionalProductImagesUrls: updatedList));
  }
}