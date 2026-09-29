import 'dart:io';
import 'dart:typed_data';
import '../../../features/media/data/models/image_model.dart';

abstract class StorageService {
  Future<String> uploadFile({required File file, required String path});

  Future<ImageModel> uploadFileBytes({
    required Uint8List bytes,
    required String path,
    required String filename,
  });

  Future<void> deleteFile({required String path, required String fullPath});
}
