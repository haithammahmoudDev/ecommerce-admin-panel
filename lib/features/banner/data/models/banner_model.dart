import '../../domain/entities/banner_entity.dart';

class BannerModel {
   String id;
 final String imageUrl;
  final bool active;
 final String targetScreen;

  BannerModel({
    this.id = '',
    required this.imageUrl,
    required this.active,
    required this.targetScreen,
  });

   factory BannerModel.fromFirebaseData(Map<String, dynamic> data,String? docId) {
    return BannerModel(
      id: docId ?? data['id'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      active: data['active'] ?? false,
      targetScreen: data['targetScreen'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'active': active,
      'targetScreen': targetScreen,
    };
  }


  BannerEntity toEntity() {
    return BannerEntity(
      id: id,
      imageUrl: imageUrl,
      active: active,
      targetScreen: targetScreen,
    );
  }

  static BannerModel empty() => BannerModel(id: '', imageUrl: '', active: false, targetScreen: '');
}
