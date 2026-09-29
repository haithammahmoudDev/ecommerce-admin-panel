import '../../domain/entities/product_variation_entity.dart';

class ProductVariationModel {
  final String id;
  String sku;
  String image;
  String? description;
  double price;
  double salePrice;
  int stock;
  int soldQuantity;
  Map<String, String> attributeValues;

  ProductVariationModel({
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

  static ProductVariationModel empty() =>
      ProductVariationModel(id: '', attributeValues: {});

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Image': image,
      'Description': description,
      'Price': price,
      'SalePrice': salePrice,
      'SKU': sku,
      'Stock': stock,
      'SoldQuantity': soldQuantity,
      'AttributeValues': attributeValues,
    };
  }

  /// Map Json / Firebase Document Data to Model (Safe parsing for both PascalCase & camelCase)
  factory ProductVariationModel.fromJson(Map<String, dynamic> document) {
    if (document.isEmpty) return ProductVariationModel.empty();

    return ProductVariationModel(
      id: document['Id'] ?? document['id'] ?? '',
      sku: document['SKU'] ?? document['sku'] ?? '',
      image: document['Image'] ?? document['image'] ?? '',
      description: document['Description'] ?? document['description'] ?? '',
      price: (document['Price'] ?? document['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (document['SalePrice'] ?? document['salePrice'] as num?)?.toDouble() ?? 0.0,
      stock: (document['Stock'] ?? document['stock'] as num?)?.toInt() ?? 0,
      soldQuantity: (document['SoldQuantity'] ?? document['soldQuantity'] as num?)?.toInt() ?? 0,
      attributeValues: Map<String, String>.from(
        document['AttributeValues'] ?? document['attributeValues'] ?? {},
      ),
    );
  }

  ProductVariationEntity toEntity() {
    return ProductVariationEntity(
      id: id,
      sku: sku,
      image: image,
      description: description,
      price: price,
      salePrice: salePrice,
      stock: stock,
      soldQuantity: soldQuantity,
      attributeValues: attributeValues,
    );
  }

  factory ProductVariationModel.fromEntity(ProductVariationEntity entity) {
    return ProductVariationModel(
      id: entity.id,
      sku: entity.sku,
      image: entity.image,
      description: entity.description,
      price: entity.price,
      salePrice: entity.salePrice,
      stock: entity.stock,
      soldQuantity: entity.soldQuantity,
      attributeValues: entity.attributeValues,
    );
  }
}