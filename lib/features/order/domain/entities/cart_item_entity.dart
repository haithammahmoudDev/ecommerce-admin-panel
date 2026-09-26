import '../../data/models/cart_item_model.dart';

class CartItemEntity {
  final String productId;
  final String title;
  final double price;
  final String? image;
  final int quantity;
  final String variationId;
  final String? brandName;
  final Map<String, String>? selectedVariation;

  CartItemEntity({
    required this.productId,
    required this.title,
    required this.price,
    this.image,
    required this.quantity,
    required this.variationId,
    this.brandName,
    this.selectedVariation,
  });

  String get totalAmount => (price * quantity).toStringAsFixed(1);

  /// Convert CartItemEntity back into a Data CartItemModel
  CartItemModel toModel() {
    return CartItemModel(
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
