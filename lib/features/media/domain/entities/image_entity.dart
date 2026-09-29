import 'dart:typed_data';

class ImageEntity {
  final String id;
  final String url;
  final String folder;
  final int? sizeBytes;
  final String mediaCategory;
  final String filename;
  final String? fullPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;
  final dynamic file;
  final Uint8List? localImageToDisplay;

  const ImageEntity({
    this.id = '',
    required this.url,
    required this.folder,
    this.sizeBytes,
    this.mediaCategory = '',
    required this.filename,
    this.fullPath,
    this.createdAt,
    this.updatedAt,
    this.contentType,
    this.file,
    this.localImageToDisplay,
  });

  /// إنشاء كائن فارغ افتراضي
  factory ImageEntity.empty() {
    return const ImageEntity(url: '', folder: '', filename: '');
  }

  factory ImageEntity.fromJson(Map<String, dynamic> json) {
    return ImageEntity(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      folder: json['folder'] ?? '',
      sizeBytes: json['sizeBytes'],
      mediaCategory: json['mediaCategory'] ?? '',
      filename: json['filename'] ?? '',
      fullPath: json['fullPath'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      contentType: json['contentType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'folder': folder,
      'sizeBytes': sizeBytes,
      'mediaCategory': mediaCategory,
      'filename': filename,
      'fullPath': fullPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'contentType': contentType,
    };
  }

  ImageEntity copyWith({
    String? id,
    String? url,
    String? folder,
    int? sizeBytes,
    String? mediaCategory,
    String? filename,
    String? fullPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contentType,
    dynamic file,
    Uint8List? localImageToDisplay,
  }) {
    return ImageEntity(
      id: id ?? this.id,
      url: url ?? this.url,
      folder: folder ?? this.folder,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      mediaCategory: mediaCategory ?? this.mediaCategory,
      filename: filename ?? this.filename,
      fullPath: fullPath ?? this.fullPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentType: contentType ?? this.contentType,
      file: file ?? this.file,
      localImageToDisplay: localImageToDisplay ?? this.localImageToDisplay,
    );
  }

  String getOptimizedUrl({int width = 300, int quality = 75}) {
    if (url.isEmpty) return url;
    return '$url?width=$width&quality=$quality&format=webp';
  }
}
