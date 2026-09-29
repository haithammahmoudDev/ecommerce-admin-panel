import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../domain/entities/image_entity.dart';

enum MediaUploadStatus { initial, loading, success, error }

class MediaState {
  final DropzoneViewController? dropzoneController;
  final bool showImagesUploaderSection;
  final MediaCategory selectedPath;
  final List<ImageEntity> selectedImagesToUpload;
  final MediaUploadStatus uploadStatus;
  final bool isLoadingMore;
  final String? errorMessage;
  final int initialLoadCount;
  final int loadMoreCount;
  final List<ImageEntity> allImages;
  final List<ImageEntity> allBannerImages;
  final List<ImageEntity> allProductImages;
  final List<ImageEntity> allBrandImages;
  final List<ImageEntity> allCategoryImages;
  final List<ImageEntity> allUserImages;
  final bool isProcessingImages;
  final int processedImagesCount;
  final int totalImagesToProcess;

  const MediaState({
    this.dropzoneController,
    this.showImagesUploaderSection = false,
    this.selectedPath = MediaCategory.folders,
    this.selectedImagesToUpload = const [],
    this.uploadStatus = MediaUploadStatus.initial,
    this.isLoadingMore = false,
    this.errorMessage,
    this.initialLoadCount = 20,
    this.loadMoreCount = 25,
    this.allImages = const [],
    this.allBannerImages = const [],
    this.allProductImages = const [],
    this.allBrandImages = const [],
    this.allCategoryImages = const [],
    this.allUserImages = const [],
    this.isProcessingImages = false,
    this.processedImagesCount = 0,
    this.totalImagesToProcess = 0,
  });

  MediaState copyWith({
    DropzoneViewController? dropzoneController,
    bool? showImagesUploaderSection,
    MediaCategory? selectedPath,
    List<ImageEntity>? selectedImagesToUpload,
    MediaUploadStatus? uploadStatus,
    bool? isLoadingMore,
    String? errorMessage,
    int? initialLoadCount,
    int? loadMoreCount,
    List<ImageEntity>? allImages,
    List<ImageEntity>? allBannerImages,
    List<ImageEntity>? allProductImages,
    List<ImageEntity>? allBrandImages,
    List<ImageEntity>? allCategoryImages,
    List<ImageEntity>? allUserImages,
    bool? isProcessingImages,
    int? processedImagesCount,
    int? totalImagesToProcess,
  }) {
    return MediaState(
      dropzoneController: dropzoneController ?? this.dropzoneController,
      showImagesUploaderSection:
          showImagesUploaderSection ?? this.showImagesUploaderSection,
      selectedPath: selectedPath ?? this.selectedPath,
      selectedImagesToUpload:
          selectedImagesToUpload ?? this.selectedImagesToUpload,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      initialLoadCount: initialLoadCount ?? this.initialLoadCount,
      loadMoreCount: loadMoreCount ?? this.loadMoreCount,
      allImages: allImages ?? this.allImages,
      allBannerImages: allBannerImages ?? this.allBannerImages,
      allProductImages: allProductImages ?? this.allProductImages,
      allBrandImages: allBrandImages ?? this.allBrandImages,
      allCategoryImages: allCategoryImages ?? this.allCategoryImages,
      allUserImages: allUserImages ?? this.allUserImages,
      isProcessingImages: isProcessingImages ?? this.isProcessingImages,
      processedImagesCount: processedImagesCount ?? this.processedImagesCount,
      totalImagesToProcess: totalImagesToProcess ?? this.totalImagesToProcess,
    );
  }
}
