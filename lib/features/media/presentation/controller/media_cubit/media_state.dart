import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../../../../../utils/constants/enums.dart';
import '../../../data/models/image_model.dart';

enum MediaUploadStatus {
  initial,
  loading,
  success,
  error,
}

class MediaState {
  final DropzoneViewController? dropzoneController;

  final bool showImagesUploaderSection;

  final MediaCategory selectedPath;

  final List<ImageModel> selectedImagesToUpload;

  final MediaUploadStatus uploadStatus;

  final bool isLoadingMore;

  final String? errorMessage;

  final int initialLoadCount;

  final int loadMoreCount;

  final List<ImageModel> allImages;

  final List<ImageModel> allBannerImages;

  final List<ImageModel> allProductImages;

  final List<ImageModel> allBrandImages;

  final List<ImageModel> allCategoryImages;

  final List<ImageModel> allUserImages;

  // ============================================================
  // IMAGE PROCESSING
  // ============================================================

  /// True while selected images are being prepared/compressed.
  final bool isProcessingImages;

  /// Number of images already processed.
  final int processedImagesCount;

  /// Total number of images currently being processed.
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

    // ==========================================================
    // IMAGE PROCESSING
    // ==========================================================

    this.isProcessingImages = false,

    this.processedImagesCount = 0,

    this.totalImagesToProcess = 0,
  });

  MediaState copyWith({
    DropzoneViewController? dropzoneController,

    bool? showImagesUploaderSection,

    MediaCategory? selectedPath,

    List<ImageModel>? selectedImagesToUpload,

    MediaUploadStatus? uploadStatus,

    bool? isLoadingMore,

    String? errorMessage,

    int? initialLoadCount,

    int? loadMoreCount,

    List<ImageModel>? allImages,

    List<ImageModel>? allBannerImages,

    List<ImageModel>? allProductImages,

    List<ImageModel>? allBrandImages,

    List<ImageModel>? allCategoryImages,

    List<ImageModel>? allUserImages,

    // ==========================================================
    // IMAGE PROCESSING
    // ==========================================================

    bool? isProcessingImages,

    int? processedImagesCount,

    int? totalImagesToProcess,
  }) {
    return MediaState(
      dropzoneController:
      dropzoneController ?? this.dropzoneController,

      showImagesUploaderSection:
      showImagesUploaderSection ??
          this.showImagesUploaderSection,

      selectedPath:
      selectedPath ?? this.selectedPath,

      selectedImagesToUpload:
      selectedImagesToUpload ??
          this.selectedImagesToUpload,

      uploadStatus:
      uploadStatus ?? this.uploadStatus,

      isLoadingMore:
      isLoadingMore ?? this.isLoadingMore,

      errorMessage:
      errorMessage,

      initialLoadCount:
      initialLoadCount ?? this.initialLoadCount,

      loadMoreCount:
      loadMoreCount ?? this.loadMoreCount,

      allImages:
      allImages ?? this.allImages,

      allBannerImages:
      allBannerImages ?? this.allBannerImages,

      allProductImages:
      allProductImages ?? this.allProductImages,

      allBrandImages:
      allBrandImages ?? this.allBrandImages,

      allCategoryImages:
      allCategoryImages ?? this.allCategoryImages,

      allUserImages:
      allUserImages ?? this.allUserImages,

      // ==========================================================
      // IMAGE PROCESSING
      // ==========================================================

      isProcessingImages:
      isProcessingImages ??
          this.isProcessingImages,

      processedImagesCount:
      processedImagesCount ??
          this.processedImagesCount,

      totalImagesToProcess:
      totalImagesToProcess ??
          this.totalImagesToProcess,
    );
  }
}