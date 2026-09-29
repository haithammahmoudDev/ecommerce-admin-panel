import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../common/errors/failure.dart';
import '../../../../utils/constants/enums.dart';
import '../entities/image_entity.dart';

abstract class MediaRepo {
  Future<Either<Failure, ImageEntity>> uploadImage({
    required Uint8List bytes,
    required String path,
    required String filename,
  });
  Future<Either<Failure, String>> saveImageRecord(ImageEntity image);
  loadMoreImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
    DateTime lastFetchedDate,
  );
  fetchImagesFromDatabase(MediaCategory mediaCategory, int loadCount);
  Future<Either<Failure, void>> deleteImage(ImageEntity image);
}
