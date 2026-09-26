import '../../domain/entities/cart_item_entity.dart';

class CartItemModel {
  final String productId;
  final String title;
  final double price;
  final String? image;
  final int quantity;
  final String variationId;
  final String? brandName;
  final Map<String, String>? selectedVariation;

  /// Constructor
  CartItemModel({
    required this.productId,
    required this.quantity,
    this.variationId = '',
    this.image,
    this.price = 0.0,
    this.title = '',
    this.brandName,
    this.selectedVariation,
  });

  /// Calculate Total Amount
  String get totalAmount => (price * quantity).toStringAsFixed(1);

  /// Empty Cart
  static CartItemModel empty() => CartItemModel(productId: '', quantity: 0);

  /// Convert Domain Entity to Data Model
  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      productId: entity.productId,
      title: entity.title,
      price: entity.price,
      image: entity.image,
      quantity: entity.quantity,
      variationId: entity.variationId,
      brandName: entity.brandName,
      selectedVariation: entity.selectedVariation,
    );
  }

  /// Factory to create CartItemModel from JSON Map
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'],
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      variationId: json['variationId'] ?? '',
      brandName: json['brandName'],
      selectedVariation: json['selectedVariation'] != null
          ? Map<String, String>.from(json['selectedVariation'] as Map)
          : null,
    );
  }

  /// Convert a CartItem to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'variationId': variationId,
      'brandName': brandName,
      'selectedVariation': selectedVariation,
    };
  }

  /// Convert CartItemModel directly into an independent CartItemEntity
  CartItemEntity toEntity() {
    return CartItemEntity(
      productId: productId,
      title: title,
      price: price,
      image: image,
      quantity: quantity,
      variationId: variationId,
      brandName: brandName,
      selectedVariation: selectedVariation,
    );
  }
}