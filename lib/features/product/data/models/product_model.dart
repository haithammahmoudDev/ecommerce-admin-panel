import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_pannal/features/product/data/models/product_attribute_model.dart';
import 'package:ecommerce_admin_pannal/features/product/data/models/product_variation_model.dart';

import '../../../../utils/formatters/formatter.dart';
import '../../../brand/data/models/brand_model.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool? isFeatured;
  BrandModel? brand;
  String? categoryId;
  String productType;
  String? description;
  List<String>? images;
  int soldQuantity;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.soldQuantity = 0,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrice = 0.0,
    this.isFeatured,
    this.categoryId,
    this.description,
    this.productAttributes,
    this.productVariations,
  });

  String get formattedDate => TFormatter.formatDate(date);

  /// Create Empty func for clean code
  static ProductModel empty() =>
      ProductModel(id: '',
          title: '',
          stock: 0,
          price: 0,
          thumbnail: '',
          productType: '');

  /// Json Format
  Map<String, dynamic> toJson() {
    return {
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryId,
      'Brand': brand?.toJson(),
      'Description': description,
      'ProductType': productType,
      'SoldQuantity': soldQuantity,
      'Date': date != null ? Timestamp.fromDate(date!) : null, // إضافة الحقل هنا
      'ProductAttributes': productAttributes != null
          ? productAttributes!.map((e) => e.toJson()).toList()
          : [],
      'ProductVariations': productVariations != null
          ? productVariations!.map((e) => e.toJson()).toList()
          : [],
    };
  }

  /// Map Json / Firebase Document Data to ProductModel
  factory ProductModel.fromFirebaseData(Map<String, dynamic>? data, String? docId) {
    if (data == null) return ProductModel.empty();

    return ProductModel(
      id:docId ?? data['id'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      price: double.tryParse((data['Price'] ?? 0.0).toString()) ?? 0.0,
      salePrice: double.tryParse((data['SalePrice'] ?? 0.0).toString()) ?? 0.0,
      thumbnail: data['Thumbnail'] ?? '',
      productType: data['ProductType'] ?? '',
      sku: data['SKU'] ?? '',
      soldQuantity: data['SoldQuantity'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      categoryId: data['CategoryId'],
      description: data['Description'],

      // handling DateTime / Timestamp
      date: data['Date'] != null
          ? (data['Date'] is Timestamp
          ? (data['Date'] as Timestamp).toDate()
          : DateTime.tryParse(data['Date'].toString()))
          : null,

      // handling List of Strings for Images
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],

      // handling Nested Object: BrandModel
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,

      // handling List of ProductAttributes
      productAttributes: data['ProductAttributes'] != null
          ? (data['ProductAttributes'] as List)
          .map((e) => ProductAttributeModel.fromJson(e))
          .toList()
          : [],

      // handling List of ProductVariations
      productVariations: data['ProductVariations'] != null
          ? (data['ProductVariations'] as List)
          .map((e) => ProductVariationModel.fromJson(e))
          .toList()
          : [],
    );
  }

  /// Converts ProductModel to ProductEntity
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      stock: stock,
      sku: sku,
      price: price,
      title: title,
      date: date,
      salePrice: salePrice,
      thumbnail: thumbnail,
      isFeatured: isFeatured,
      brand: brand?.toEntity(),
      categoryId: categoryId,
      productType: productType,
      description: description,
      images: images,
      soldQuantity: soldQuantity,
      productAttributes: productAttributes?.map((e) => e.toEntity()).toList(),
      productVariations: productVariations?.map((e) => e.toEntity()).toList(),
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      stock: entity.stock,
      price: entity.price,
      thumbnail: entity.thumbnail,
      productType: entity.productType,
      soldQuantity: entity.soldQuantity,
      sku: entity.sku,
      brand: entity.brand != null ? BrandModel.fromEntity(entity.brand!) : null,
      date: entity.date,
      images: entity.images,
      salePrice: entity.salePrice,
      isFeatured: entity.isFeatured,
      categoryId: entity.categoryId,
      description: entity.description,
      productAttributes: entity.productAttributes
          ?.map((e) => ProductAttributeModel.fromEntity(e))
          .toList(),
      productVariations: entity.productVariations
          ?.map((e) => ProductVariationModel.fromEntity(e))
          .toList(),
    );
  }


}