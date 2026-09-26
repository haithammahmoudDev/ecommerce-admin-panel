import 'dart:typed_data';

import 'package:ecommerce_admin_pannal/features/media/data/repo/media_repo_imple.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/loaders/circular_loader.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/popups/dialog.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../data/models/image_model.dart';
import '../../widgets/media_content.dart';
import '../../widgets/media_uploader.dart';
import '../../widgets/web_image_resizer.dart';
import 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  final MediaRepository _mediaRepository;

  MediaCubit({
    required MediaRepository mediaRepository,
  })  : _mediaRepository = mediaRepository,
        super(const MediaState());

  DropzoneViewController? dropzoneController;

  void toggleImagesUploaderSection() {
    emit(
      state.copyWith(
        showImagesUploaderSection: !state.showImagesUploaderSection,
      ),
    );
  }

  /// toggle selected image (Single or Multiple Selection)
  void toggleImageSelection(ImageModel targetImage, {bool allowMultipleSelection = false}) {
    // 1. أخذ نسخة من قائمة الصور المحددة حالياً
    final List<ImageModel> currentSelected = List<ImageModel>.from(state.selectedImagesToUpload);

    // 2. التحقق مما إذا كانت الصورة محددة مسبقاً
    final bool isAlreadySelected = currentSelected.any((img) => img.id == targetImage.id || img.url == targetImage.url);

    List<ImageModel> updatedList = [];

    if (isAlreadySelected) {
      // إلغاء تحديد الصورة
      updatedList = currentSelected.where((img) => img.id != targetImage.id && img.url != targetImage.url).toList();
    } else {
      // تحديد الصورة
      if (!allowMultipleSelection) {
        // إذا كان التحديد لصورة واحدة فقط، امسح القائمة القديمة وأضف الجديدة فقط
        updatedList = [targetImage];
      } else {
        // إذا كان التحديد متعدد، أضف الصورة للقائمة
        updatedList = [...currentSelected, targetImage];
      }
    }

    // 3. تحديث الـ State
    emit(
      state.copyWith(
        selectedImagesToUpload: updatedList,
      ),
    );
  }

  void updateSelectedPath(MediaCategory category) {
    emit(
      state.copyWith(
        selectedPath: category,
      ),
    );
  }

  void setDropzoneController(DropzoneViewController controller) {
    dropzoneController = controller;
  }

  // ============================================================
  // PICK LOCAL IMAGES (معالجة وضغط متوازي للصور عند الاختيار)
  // ============================================================

  Future<void> selectLocalImages() async {
    if (dropzoneController == null) return;

    try {
      final files = await dropzoneController!.pickFiles(
        multiple: true,
        mime: ['image/jpeg', 'image/png', 'image/webp'],
      );

      if (files != null && files.isNotEmpty) {
        // 🟢 قراءة وضغط جميع الملفات المختارة بالتوازي لسرعة فائقة
        final imageModels = await Future.wait(
          files.map((file) async {
            final bytes = await dropzoneController!.getFileData(file);
            final filename = await dropzoneController!.getFilename(file);
            final rawBytes = Uint8List.fromList(bytes);

            // ضغط فوري للصورة
            final compressedBytes = await WebImageResizer.resizeImage(rawBytes);

            return ImageModel(
              url: '',
              file: file,
              folder: state.selectedPath.name,
              filename: filename,
              localImageToDisplay: compressedBytes,
            );
          }),
        );

        // إضافة جميع الصور دفعة واحدة إلى الـ State
        final updatedList = List<ImageModel>.from(state.selectedImagesToUpload)
          ..addAll(imageModels);

        emit(
          state.copyWith(
            selectedImagesToUpload: updatedList,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error picking files: $e');
    }
  }

  void addSelectedImageModel(ImageModel image) {
    final updatedList = List<ImageModel>.from(state.selectedImagesToUpload)
      ..add(image);

    emit(
      state.copyWith(
        selectedImagesToUpload: updatedList,
      ),
    );
  }

  void clearAllSelectedImages() {
    emit(
      state.copyWith(
        selectedImagesToUpload: const [],
      ),
    );
  }

  // ============================================================
  // UPLOAD CONFIRMATION
  // ============================================================

  void uploadImagesConfirmation(BuildContext context) {
    if (state.selectedPath == MediaCategory.folders) {
      TLoaders.warningSnackBar(
        title: 'Select Folder',
        message: 'Please select the Folder in order to upload the Images.',
        context: context,
      );
      return;
    }

    TDialogs.defaultDialog(
      context: context,
      title: 'Upload Images',
      confirmText: 'Upload',
      onConfirm: () async => await uploadImages(context),
      content:
      'Are you sure you want to upload all the Images in ${state.selectedPath.name.toUpperCase()} folder?',
    );
  }

  // ============================================================
  // UPLOAD IMAGES (رفع بالتوازي مع دمج التخزين والداتا بيز)
  // ============================================================

  Future<void> uploadImages(BuildContext context) async {
    final stopwatch = Stopwatch()..start();

    context.pop(); // إغلاق Confirm Dialog
    uploadImagesLoader(context); // فتح الـ Loader

    final MediaCategory selectedCategory = state.selectedPath;
    List<ImageModel> targetList;

    switch (selectedCategory) {
      case MediaCategory.banners:
        targetList = List<ImageModel>.from(state.allBannerImages);
        break;
      case MediaCategory.brands:
        targetList = List<ImageModel>.from(state.allBrandImages);
        break;
      case MediaCategory.categories:
        targetList = List<ImageModel>.from(state.allCategoryImages);
        break;
      case MediaCategory.products:
        targetList = List<ImageModel>.from(state.allProductImages);
        break;
      case MediaCategory.users:
        targetList = List<ImageModel>.from(state.allUserImages);
        break;
      default:
        if (context.mounted) context.pop();
        return;
    }

    final List<ImageModel> selectedImagesToUpload =
    List<ImageModel>.from(state.selectedImagesToUpload);

    // 🟢 رفع وحفظ كل صورة بالتوازي فور جهوزيتها
    final List<ImageModel?> uploadResults = await Future.wait(
      selectedImagesToUpload.map((selectedImage) async {
        final bytes = selectedImage.localImageToDisplay;
        if (bytes == null) return null;

        // 1. رفع الصورة لـ Storage
        final storageResult = await _mediaRepository.uploadImage(
          bytes: bytes,
          path: selectedCategory.name,
          filename: selectedImage.filename,
        );

        return await storageResult.fold(
              (failure) => null,
              (uploadedImage) async {
            final imageWithCategory = uploadedImage.copyWith(
              mediaCategory: selectedCategory.name,
            );

            // 2. حفظ سجل الصورة في Database فور انتهاء الرفع مباشرة
            final dbResult = await _mediaRepository.saveImageRecord(imageWithCategory);
            return dbResult.fold(
                  (failure) => imageWithCategory,
                  (id) => imageWithCategory.copyWith(id: id),
            );
          },
        );
      }),
    );

    final validUploadedImages = uploadResults.whereType<ImageModel>().toList();

    targetList.addAll(validUploadedImages);

    // تحديث الـ State والتفريغ
    emit(
      state.copyWith(
        allBannerImages: selectedCategory == MediaCategory.banners ? targetList : null,
        allBrandImages: selectedCategory == MediaCategory.brands ? targetList : null,
        allCategoryImages: selectedCategory == MediaCategory.categories ? targetList : null,
        allProductImages: selectedCategory == MediaCategory.products ? targetList : null,
        allUserImages: selectedCategory == MediaCategory.users ? targetList : null,
        allImages: [...state.allImages, ...validUploadedImages],
        selectedImagesToUpload: const [],
      ),
    );

    if (context.mounted) {
      context.pop();
    }

    debugPrint('⏱️ TOTAL TIME: ${stopwatch.elapsedMilliseconds}ms');
  }

  // ============================================================
  // UPLOAD LOADER
  // ============================================================

  void uploadImagesLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Uploading Images'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  TImages.uploadingImageIllustration,
                  key: UniqueKey(),
                  height: 300,
                  width: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Text('Sit Tight, Your images are uploading...'),
              ],
            ),
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  // ============================================================
  // GET MEDIA IMAGES & OTHER METHODS
  // ============================================================

  Future<void> getMediaImages() async {
    bool shouldFetch = false;

    switch (state.selectedPath) {
      case MediaCategory.banners:
        shouldFetch = state.allBannerImages.isEmpty;
        break;
      case MediaCategory.brands:
        shouldFetch = state.allBrandImages.isEmpty;
        break;
      case MediaCategory.categories:
        shouldFetch = state.allCategoryImages.isEmpty;
        break;
      case MediaCategory.products:
        shouldFetch = state.allProductImages.isEmpty;
        break;
      case MediaCategory.users:
        shouldFetch = state.allUserImages.isEmpty;
        break;
      default:
        shouldFetch = state.allImages.isEmpty;
    }

    if (!shouldFetch) {
      emit(state.copyWith(uploadStatus: MediaUploadStatus.success));
      return;
    }

    emit(state.copyWith(uploadStatus: MediaUploadStatus.loading));

    final failureOrImages = await _mediaRepository.fetchImagesFromDatabase(
      state.selectedPath,
      state.initialLoadCount,
    );

    failureOrImages.fold(
          (failure) {
        emit(
          state.copyWith(
            uploadStatus: MediaUploadStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
          (images) {
        switch (state.selectedPath) {
          case MediaCategory.banners:
            emit(
              state.copyWith(
                allBannerImages: images,
                allImages: [...state.allImages, ...images],
                uploadStatus: MediaUploadStatus.success,
              ),
            );
            break;
          case MediaCategory.brands:
            emit(
              state.copyWith(
                allBrandImages: images,
                allImages: [...state.allImages, ...images],
                uploadStatus: MediaUploadStatus.success,
              ),
            );
            break;
          case MediaCategory.categories:
            emit(
              state.copyWith(
                allCategoryImages: images,
                allImages: [...state.allImages, ...images],
                uploadStatus: MediaUploadStatus.success,
              ),
            );
            break;
          case MediaCategory.products:
            emit(
              state.copyWith(
                allProductImages: images,
                allImages: [...state.allImages, ...images],
                uploadStatus: MediaUploadStatus.success,
              ),
            );
            break;
          case MediaCategory.users:
            emit(
              state.copyWith(
                allUserImages: images,
                allImages: [...state.allImages, ...images],
                uploadStatus: MediaUploadStatus.success,
              ),
            );
            break;
          default:
            emit(
              state.copyWith(
                allImages: images,
                uploadStatus: MediaUploadStatus.success,
              ),
            );
        }
      },
    );
  }

  Future<void> loadMoreMediaImages() async {
    List<ImageModel> targetList = [];

    switch (state.selectedPath) {
      case MediaCategory.banners:
        targetList = state.allBannerImages;
        break;
      case MediaCategory.brands:
        targetList = state.allBrandImages;
        break;
      case MediaCategory.categories:
        targetList = state.allCategoryImages;
        break;
      case MediaCategory.products:
        targetList = state.allProductImages;
        break;
      case MediaCategory.users:
        targetList = state.allUserImages;
        break;
      default:
        targetList = state.allImages;
    }

    if (targetList.isEmpty) return;

    emit(state.copyWith(isLoadingMore: true));

    final lastFetchedDate = targetList.last.createdAt ?? DateTime.now();

    final failureOrImages = await _mediaRepository.loadMoreImagesFromDatabase(
      state.selectedPath,
      state.initialLoadCount,
      lastFetchedDate,
    );

    failureOrImages.fold(
          (failure) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            errorMessage: failure.message,
          ),
        );
      },
          (newImages) {
        final updatedList = List<ImageModel>.from(targetList)..addAll(newImages);
        final updatedAllImages = List<ImageModel>.from(state.allImages)..addAll(newImages);

        switch (state.selectedPath) {
          case MediaCategory.banners:
            emit(state.copyWith(allBannerImages: updatedList, allImages: updatedAllImages, isLoadingMore: false));
            break;
          case MediaCategory.brands:
            emit(state.copyWith(allBrandImages: updatedList, allImages: updatedAllImages, isLoadingMore: false));
            break;
          case MediaCategory.categories:
            emit(state.copyWith(allCategoryImages: updatedList, allImages: updatedAllImages, isLoadingMore: false));
            break;
          case MediaCategory.products:
            emit(state.copyWith(allProductImages: updatedList, allImages: updatedAllImages, isLoadingMore: false));
            break;
          case MediaCategory.users:
            emit(state.copyWith(allUserImages: updatedList, allImages: updatedAllImages, isLoadingMore: false));
            break;
          default:
            emit(state.copyWith(allImages: updatedAllImages, isLoadingMore: false));
        }
      },
    );
  }

  void removeCloudImageConfirmation(BuildContext context, ImageModel image) {
    TDialogs.defaultDialog(
      context: context,
      content: 'Are you sure you want to delete this image?',
      onConfirm: () {
        context.pop();
        removeCloudImage(context, image);
      },
    );
  }

  Future<void> removeCloudImage(BuildContext context, ImageModel image) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final messenger = ScaffoldMessenger.of(context);

    if (navigator.mounted) navigator.pop();

    showDialog(
      context: navigator.context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: SizedBox(
            width: 70,
            height: 70,
            child: TCircularLoader(),
          ),
        ),
      ),
    );

    final result = await _mediaRepository.deleteImage(image);

    result.fold(
          (failure) {
        if (navigator.mounted) navigator.pop();
        messenger.showSnackBar(SnackBar(content: Text(failure.message)));
      },
          (_) {
        List<ImageModel> targetList;

        switch (state.selectedPath) {
          case MediaCategory.banners:
            targetList = List<ImageModel>.from(state.allBannerImages);
            break;
          case MediaCategory.brands:
            targetList = List<ImageModel>.from(state.allBrandImages);
            break;
          case MediaCategory.categories:
            targetList = List<ImageModel>.from(state.allCategoryImages);
            break;
          case MediaCategory.products:
            targetList = List<ImageModel>.from(state.allProductImages);
            break;
          case MediaCategory.users:
            targetList = List<ImageModel>.from(state.allUserImages);
            break;
          default:
            if (navigator.mounted) navigator.pop();
            return;
        }

        targetList.removeWhere((item) => item.id == image.id);
        final updatedAllImages = state.allImages.where((item) => item.id != image.id).toList();

        switch (state.selectedPath) {
          case MediaCategory.banners:
            emit(state.copyWith(allBannerImages: targetList, allImages: updatedAllImages));
            break;
          case MediaCategory.brands:
            emit(state.copyWith(allBrandImages: targetList, allImages: updatedAllImages));
            break;
          case MediaCategory.categories:
            emit(state.copyWith(allCategoryImages: targetList, allImages: updatedAllImages));
            break;
          case MediaCategory.products:
            emit(state.copyWith(allProductImages: targetList, allImages: updatedAllImages));
            break;
          case MediaCategory.users:
            emit(state.copyWith(allUserImages: targetList, allImages: updatedAllImages));
            break;
          default:
            break;
        }

        if (navigator.mounted) navigator.pop();
        messenger.showSnackBar(
          const SnackBar(content: Text('Image successfully deleted from your cloud storage')),
        );
      },
    );
  }
  void setShowImagesUploaderSection(bool show) {
    emit(state.copyWith(showImagesUploaderSection: show));
  }

  Future<List<ImageModel>?> selectImagesFromMedia({
    required BuildContext context,
    List<String>? selectedUrls,
    bool allowSelection = true,
    bool allowMultipleSelection = false,
  }) async {
    clearAllSelectedImages();

    setShowImagesUploaderSection(true);

    final List<ImageModel>? selectedImages =
    await showModalBottomSheet<List<ImageModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TColors.primaryBackground,
      builder: (BuildContext sheetContext) {
        return BlocProvider.value(
          value: this,
          child: FractionallySizedBox(
            heightFactor: 1.0,
            child: Material(
              color: TColors.primaryBackground,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    children: [
                      MediaUploader(),

                      MediaContent(
                        allowSelection: allowSelection,
                        alreadySelectedUrls: selectedUrls ?? [],
                        allowMultipleSelection: allowMultipleSelection,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return selectedImages;
  }

}