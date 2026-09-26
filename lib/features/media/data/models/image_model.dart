import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Model class representing image data.
class ImageModel {
  String id;
  final String url;
  final String folder;
  final int? sizeBytes;
  String mediaCategory;
  final String filename;
  final String? fullPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;

  // Not Mapped Fields
  final dynamic file;
  bool isSelected;
  final Uint8List? localImageToDisplay;

  /// Constructor for ImageModel
  ImageModel({
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
    this.isSelected = false,
    this.localImageToDisplay,
  });

  /// Factory constructor for creating an empty ImageModel.
  factory ImageModel.empty() {
    return ImageModel(
      url: '',
      folder: '',
      filename: '',
    );
  }

  /// Convert to JSON structure for storing in Firestore database
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'folder': folder,
      'sizeBytes': sizeBytes ?? 0,
      'filename': filename,
      'fullPath': fullPath ?? '',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'contentType': contentType ?? '',
      'mediaCategory': mediaCategory,
    };
  }

  /// Convert Firestore Json and Map on Model
  factory ImageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return ImageModel(
        id: document.id,
        url: data['url'] ?? '',
        folder: data['folder'] ?? '',
        sizeBytes: data['sizeBytes'] ?? 0,
        filename: data['filename'] ?? '',
        fullPath: data['fullPath'] ?? '',
        createdAt: data.containsKey('createdAt') && data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
        updatedAt: data.containsKey('updatedAt') && data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
        contentType: data['contentType'] ?? '',
        mediaCategory: data['mediaCategory'] ?? '',
      );
    } else {
      return ImageModel.empty();
    }
  }

  /// Map Firebase Storage Data
  factory ImageModel.fromFirebaseMetadata(FullMetadata metadata
      , String folder, String filename, String downloadUrl) {
    return ImageModel(
      url: downloadUrl,
      folder: folder,
      filename: filename,
      sizeBytes: metadata.size,
      updatedAt: metadata.updated,
      fullPath: metadata.fullPath,
      createdAt: metadata.timeCreated,
      contentType: metadata.contentType,
    );
  }

  ImageModel copyWith({
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
    bool? isSelected,
    Uint8List? localImageToDisplay,
  }) {
    return ImageModel(
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
      isSelected: isSelected ?? this.isSelected,
      localImageToDisplay: localImageToDisplay ?? this.localImageToDisplay,
    );
  }

  factory ImageModel.fromJson(Map<String, dynamic> data) {
    return ImageModel(
      id: data['id'] ?? '',
      url: data['url'] ?? '',
      folder: data['folder'] ?? '',
      sizeBytes: data['sizeBytes'] ?? 0,
      filename: data['filename'] ?? '',
      fullPath: data['fullPath'] ?? '',
      createdAt: data.containsKey('createdAt') && data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data.containsKey('updatedAt') && data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      contentType: data['contentType'] ?? '',
      mediaCategory: data['mediaCategory'] ?? '',
    );
  }
  String getOptimizedUrl({int width = 300, int quality = 75}) {
    if (url.isEmpty) return url;
    return '$url?width=$width&quality=$quality&format=webp';
  }
}
