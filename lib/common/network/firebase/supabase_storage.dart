import 'dart:io';
import 'dart:typed_data';
import 'package:ecommerce_admin_pannal/common/network/firebase/storage_service.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/media/data/models/image_model.dart';

class SupabaseStorageService implements StorageService {
  final SupabaseClient client;

  SupabaseStorageService(this.client);

  @override
  Future<String> uploadFile({required File file, required String path}) async {
    final String extension = p.extension(file.path);
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}$extension';

    await client.storage
        .from(path)
        .upload(fileName, file, fileOptions: const FileOptions(upsert: true));
    return client.storage.from(path).getPublicUrl(fileName);
  }

  @override
  Future<ImageModel> uploadFileBytes({
    required Uint8List bytes,
    required String path,
    required String filename,
  }) async {
    final String extension = p.extension(filename);
    final String generatedName =
        '${DateTime.now().millisecondsSinceEpoch}$extension';
    final String fullStoragePath = '$path/$generatedName';

    await client.storage
        .from(path)
        .uploadBinary(
          generatedName,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: _getContentType(extension),
          ),
        );

    final downloadURL = client.storage.from(path).getPublicUrl(generatedName);

    return ImageModel(
      url: downloadURL,
      file: null,
      folder: path,
      filename: filename,
      localImageToDisplay: bytes,
      contentType: _getContentType(extension),
      fullPath: fullStoragePath,
      sizeBytes: bytes.length,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      mediaCategory: path,
    );
  }

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.svg':
        return 'image/svg+xml';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Future<void> deleteFile({
    required String path,
    required String fullPath,
  }) async {
    try {
      final String filePath = fullPath.startsWith('$path/')
          ? fullPath.substring(path.length + 1)
          : fullPath;

      await client.storage.from(path).remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }
}
