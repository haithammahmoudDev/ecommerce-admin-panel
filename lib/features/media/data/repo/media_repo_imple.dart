import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/features/media/domain/entities/image_entity.dart';
import '../../../../common/errors/failure.dart';
import '../../../../common/network/firebase/database_services.dart';
import '../../../../common/network/firebase/storage_service.dart';
import '../../../../utils/constants/enums.dart';
import '../../domain/repo/media_repo.dart';
import '../models/image_model.dart';

class MediaRepositoryImple implements MediaRepo {
  final StorageService storageService;
  final DatabaseServices databaseServices;
  MediaRepositoryImple({
    required this.storageService,
    required this.databaseServices,
  });

  @override
  Future<Either<Failure, ImageEntity>> uploadImage({
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
      return Right(image.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveImageRecord(ImageEntity image) async {
    try {
      final id = await databaseServices.addDataAndGetId(
        path: 'images',
        data: ImageModel.fromEntity(image).toJson(),
      );
      return Right(id);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ImageEntity>>> loadMoreImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
    DateTime lastFetchedDate,
  ) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('images')
          .where('mediaCategory', isEqualTo: mediaCategory.name.toString())
          .orderBy('createdAt', descending: true)
          .startAfter([Timestamp.fromDate(lastFetchedDate)])
          .limit(loadCount)
          .get();

      final List<ImageModel> imageModellist = data.docs
          .map((e) => ImageModel.fromJson(e.data()))
          .toList();

      return Right(imageModellist.map((e)=> e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ImageEntity>>> fetchImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
  ) async {
    try {
      final result = await databaseServices.getData(
        path: 'images',
        query: {
          'where': {'field': 'mediaCategory', 'value': mediaCategory.name},
          'orderBy': 'createdAt',
          'descending': true,
          'limit': loadCount,
        },
      );

      final images = (result as List)
          .map((data) => ImageModel.fromJson(data as Map<String, dynamic>))
          .toList();

      return Right(images.map((e)=> e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage(ImageEntity image) async {
    try {
      await storageService.deleteFile(
        path: image.folder,
        fullPath: image.fullPath!,
      );

      await databaseServices.deleteData(path: 'images', docId: image.id);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
