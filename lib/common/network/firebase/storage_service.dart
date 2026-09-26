import 'dart:io';
import 'dart:typed_data';

import '../../../features/media/data/models/image_model.dart';

abstract class StorageService {
  // الدالة القديمة - زي ما هي بالظبط من غير أي تعديل
  Future<String> uploadFile({
    required File file,
    required String path,
  });

  // ✅ بترجع ImageModel كامل بدل String (زي الفيديو بالظبط)
  Future<ImageModel> uploadFileBytes({
    required Uint8List bytes,
    required String path,
    required String filename,
  });

  Future<void> deleteFile({
    required String path,
    required String fullPath,
  });
}