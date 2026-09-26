import 'dart:io';
import 'dart:typed_data';

import 'package:ecommerce_admin_pannal/common/network/firebase/storage_service.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/media/data/models/image_model.dart';

class SupabaseStorageService implements StorageService {
  final SupabaseClient client;

  SupabaseStorageService(this.client);

  // الدالة القديمة - زي ما هي بالظبط من غير أي تعديل
  @override
  Future<String> uploadFile({
    required File file,
    required String path,
  }) async {
    final extension = p.extension(file.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$extension';
    final storagePath = '$fileName';

    print("Bucket = $path");
    print("StoragePath = $storagePath");

    final response = await client.storage
        .from(path)
        .upload(
      storagePath,
      file,
      fileOptions: const FileOptions(
        upsert: true,
      ),
    );

    print(response);

    return client.storage
        .from(path)
        .getPublicUrl(storagePath);
  }

  // ✅ محدّثة: بتملأ contentType, fullPath, sizeBytes, createdAt, mediaCategory كلهم
  @override
  Future<ImageModel> uploadFileBytes({
    required Uint8List bytes,
    required String path,
    required String filename,
  }) async {
    final extension = p.extension(filename);
    // اسم فريد لتخزين الملف فعليًا (يمنع تعارض الأسماء)
    final generatedName = '${DateTime.now().millisecondsSinceEpoch}$extension';
    final fullStoragePath = '$path/$generatedName';

    print("Bucket = $path");
    print("StoragePath = $generatedName");

    final response = await client.storage
        .from(path)
        .uploadBinary(
      generatedName,
      bytes,
      fileOptions: FileOptions(
        upsert: true,
        contentType: _getContentType(extension), // ✅ نبعت الـ contentType وقت الرفع نفسه
      ),
    );

    print(response);

    final downloadURL = client.storage
        .from(path)
        .getPublicUrl(generatedName);

    // بناء ImageModel كامل - كل الحقول محسوبة دلوقتي
    return ImageModel(
      url: downloadURL,
      file: null,
      folder: path,
      filename: filename,                        // ✅ الاسم الأصلي - مش الاسم المولّد
      localImageToDisplay: bytes,
      contentType: _getContentType(extension),    // ✅ محسوب من الامتداد
      fullPath: fullStoragePath,                  // ✅ المسار الكامل زي "banners/xxxx.jpg"
      sizeBytes: bytes.length,                    // ✅ حجم الملف الفعلي بالبايت
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      mediaCategory: path,
    );
  }

  // ✅ دالة مساعدة بسيطة تحدد contentType حسب امتداد الملف
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
      // fullPath = products/172478923.jpg
      // path = products

      final filePath = fullPath.startsWith('$path/')
          ? fullPath.substring(path.length + 1)
          : fullPath;

      await client.storage
          .from(path)
          .remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }
  }