import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_attribute_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_variation_entity.dart';
import 'package:intl/intl.dart';
import '../../../brand/domain/entities/brand_entity.dart';

class ProductEntity {
  final String id;
  final int stock;
  final String? sku;
  final double price;
  final String title;
  final DateTime? date;
  final double salePrice;
  final String thumbnail;
  final bool? isFeatured;
  final BrandEntity? brand;
  final String? categoryId;
  final String productType;
  final String? description;
  final List<String>? images;
  final int soldQuantity;
  final List<ProductAttributeEntity>? productAttributes;
  final List<ProductVariationEntity>? productVariations;

  const ProductEntity({
    required this.id,
    required this.stock,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.soldQuantity = 0,
    this.sku,
    this.date,
    this.images,
    this.brand,
    this.categoryId,
    this.description,
    this.isFeatured,
    this.salePrice = 0.0,
    this.productAttributes,
    this.productVariations,
  });

  String get formattedDate => DateFormat('dd MMM yyyy').format(date ?? DateTime.now());
}