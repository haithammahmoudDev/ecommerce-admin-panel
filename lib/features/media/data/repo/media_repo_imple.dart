import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../common/errors/failure.dart';
import '../../../../common/network/firebase/database_services.dart';
import '../../../../common/network/firebase/storage_service.dart';
import '../../../../utils/constants/enums.dart';
import '../models/image_model.dart';

class MediaRepository {
  final StorageService storageService; // ✅ Supabase - الرفع
  final DatabaseServices databaseServices; // ✅ Firestore - الحفظ

  MediaRepository(
      this.storageService,
      this.databaseServices,
      );

  /// الخطوة 1: بترفع صورة واحدة لـ Supabase Storage وترجع Either:
  /// - Left(Failure) لو حصل خطأ
  /// - Right(ImageModel) الصورة كاملة بعد الرفع
  Future<Either<Failure, ImageModel>> uploadImage({
    required Uint8List bytes,
    required String path,
    required String filename,
  }) async {
    try {
      final image = await storageService.uploadFileBytes(
        bytes: bytes,
        path: path,
        filename: filename,
      );

      return Right(image);
    } catch (e) {
      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  /// Save image information in Firestore
  Future<Either<Failure, String>> saveImageRecord(
      ImageModel image,
      ) async {
    try {
      final id = await databaseServices.addDataAndGetId(
        path: 'images',
        data: image.toJson(),
      );

      return Right(id);
    } catch (e) {
      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  /// Load more images using pagination
  Future<Either<Failure, List<ImageModel>>>
  loadMoreImagesFromDatabase(
      MediaCategory mediaCategory,
      int loadCount,
      DateTime lastFetchedDate,
      ) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('images')
          .where(
        'mediaCategory',
        isEqualTo: mediaCategory.name.toString(),
      )
          .orderBy(
        'createdAt',
        descending: true,
      )
          .startAfter([
        Timestamp.fromDate(
          lastFetchedDate,
        ),
      ])
          .limit(loadCount)
          .get();

      final List<ImageModel> imageModellist = data.docs
          .map(
            (e) => ImageModel.fromJson(
          e.data(),
        ),
      )
          .toList();

      return Right(
        imageModellist,
      );
    } catch (e) {
      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  /// Fetch first images from Firestore
  Future<Either<Failure, List<ImageModel>>>
  fetchImagesFromDatabase(
      MediaCategory mediaCategory,
      int loadCount,
      ) async {
    try {
      final result = await databaseServices.getData(
        path: 'images',
        query: {
          'where': {
            'field': 'mediaCategory',
            'value': mediaCategory.name,
          },
          'orderBy': 'createdAt',
          'descending': true,
          'limit': loadCount,
        },
      );

      final images = (result as List)
          .map(
            (data) => ImageModel.fromJson(
          data as Map<String, dynamic>,
        ),
      )
          .toList();

      return Right(
        images,
      );
    } catch (e) {
      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  /// Delete image from Supabase Storage
  /// and Firestore
  Future<Either<Failure, void>> deleteImage(
      ImageModel image,
      ) async {
    try {
      // 1. Delete image from Supabase Storage
      await storageService.deleteFile(
        path: image.folder,
        fullPath: image.fullPath!,
      );

      // 2. Delete image document from Firestore
      await databaseServices.deleteData(
        path: 'images',
        docId: image.id,
      );

      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }
}