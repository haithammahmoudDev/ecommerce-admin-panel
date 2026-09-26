import '../../domain/entities/product_attribute_entity.dart';

class ProductAttributeModel {
  String? name;
  final List<String>? values;

  ProductAttributeModel({this.name, this.values});

  /// Json Format
  toJson() {
    return {'Name': name, 'Values': values};
  }

  /// Map json oriented document snapshot from Firebase to Model
  factory ProductAttributeModel.fromJson(Map<String, dynamic> document) {
    final data = document;

    if (data.isEmpty) return ProductAttributeModel();

    return ProductAttributeModel(
      name: data.containsKey('Name') ? data['Name'] : '',
      values: List<String>.from(data['Values']),
    );
  }

  /// Convert Model to Entity
  ProductAttributeEntity toEntity() {
    return ProductAttributeEntity(
      name: name,
      values: values,
    );
  }

  factory ProductAttributeModel.fromEntity(ProductAttributeEntity entity) {
    return ProductAttributeModel(
      name: entity.name,
      values: entity.values,
    );
  }
}