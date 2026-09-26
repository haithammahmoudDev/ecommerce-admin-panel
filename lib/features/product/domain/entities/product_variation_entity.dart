import 'package:equatable/equatable.dart';

class ProductVariationEntity extends Equatable {
  final String id;
  final String sku;
  final String image;
  final String? description;
  final double price;
  final double salePrice;
  final int stock;
  final int soldQuantity;
  final Map<String, String> attributeValues;

  const ProductVariationEntity({
    required this.id,
    this.sku = '',
    this.image = '',
    this.description = '',
    this.price = 0.0,
    this.salePrice = 0.0,
    this.stock = 0,
    this.soldQuantity = 0,
    required this.attributeValues,
  });

  ProductVariationEntity copyWith({
    String? id,
    String? sku,
    String? image,
    String? description,
    double? price,
    double? salePrice,
    int? stock,
    int? soldQuantity,
    Map<String, String>? attributeValues,
  }) {
    return ProductVariationEntity(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      image: image ?? this.image,
      description: description ?? this.description,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      stock: stock ?? this.stock,
      soldQuantity: soldQuantity ?? this.soldQuantity, // تم تصحيح الخطأ هنا
      attributeValues: attributeValues ?? this.attributeValues,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sku,
    image,
    description,
    price,
    salePrice,
    stock,
    soldQuantity,
    attributeValues,
  ];
}