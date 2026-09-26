import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/features/product/data/models/product_model.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/repos/product_repo.dart';
import 'package:flutter/cupertino.dart';

import '../../../../common/abstraction/base_data_table/base_data_table_cubit.dart';
import '../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../utils/popups/loaders.dart';

class ProductCubit extends BaseDataTableCubit<ProductEntity> {
  final ProductRepo _productRepo;

  ProductCubit({required ProductRepo productRepo})
      : _productRepo = productRepo,
        super();

  /// Fetch all products as Entities from the repository
  @override
  Future<Either<Failure, List<ProductEntity>>> fetchItems() async {
    return await _productRepo.fetchAllProducts();
  }

  /// Unique identifier getter for BaseDataTableCubit
  @override
  String getItemId(ProductEntity item) {
    return item.id;
  }

  /// Search filter logic for data table
  @override
  bool filterCondition(ProductEntity item, String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase().trim();

    return item.title.toLowerCase().contains(lowerQuery) ||
        (item.brand != null && item.brand!.name.toLowerCase().contains(lowerQuery)) ||
        item.stock.toString().contains(lowerQuery) ||
        item.price.toString().contains(lowerQuery) ||
        (item.sku != null && item.sku!.toLowerCase().contains(lowerQuery));
  }

  Future<void> deleteOnConfirm(ProductEntity product, BuildContext context) async {
    emit(state.copyWith(status: DataTableStatus.loading));

    final result = await _productRepo.deleteProduct(ProductModel.fromEntity(product));

    result.fold(
          (error) {
        emit(state.copyWith(status: DataTableStatus.error, errorMessage: error.toString()));
        if (!context.mounted) return;
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString(), context: context);
      },
          (_) {
        removeItemFromLists(product);
        if (!context.mounted) return;
        TLoaders.successSnackBar(
          title: 'Item Deleted',
          message: 'Your Item has been Deleted',
          context: context,
        );
      },
    );
  }
  // ===========================================================================
  // Sorting Methods
  // ===========================================================================

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (ProductEntity product) => product.title.toLowerCase(),
    );
  }

  void sortByPrice(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (ProductEntity product) => product.price,
    );
  }

  void sortByStock(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (ProductEntity product) => product.stock,
    );
  }

  void sortBySoldItems(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (ProductEntity product) => product.soldQuantity,
    );
  }

  // ===========================================================================
  // UI Helpers
  // ===========================================================================

  /// Calculate formatted price or price range for product variations
  String getProductPrice(ProductEntity product) {
    // FIX: كانت تقارن بـ 'ProductType.single' فقط، فلا تطابق المنتجات
    // المخزَّنة بصيغة .name ("single"). أضفنا الشكلين معاً بدون تغيير باقي المنطق.
    if (product.productType == 'ProductType.single' ||
        product.productType == 'single' ||
        product.productVariations == null ||
        product.productVariations!.isEmpty) {
      return (product.salePrice > 0 ? product.salePrice : product.price).toString();
    } else {
      double smallestPrice = double.infinity;
      double largestPrice = 0.0;

      for (var variation in product.productVariations!) {
        double priceToConsider =
        variation.salePrice > 0.0 ? variation.salePrice : variation.price;

        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }
        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      if (smallestPrice.isInfinite) return product.price.toString();

      if (smallestPrice == largestPrice) {
        return largestPrice.toString();
      } else {
        return '\$$smallestPrice - \$$largestPrice';
      }
    }
  }

  // ===========================================================================
  // Product Helper Methods
  // ===========================================================================

  /// Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// Calculate Product Stock
  String getProductStockTotal(ProductEntity product) {
    // FIX: كانت تعمل force unwrap (productVariations!) بدون حماية null،
    // وتقارن بصيغة .toString() فقط، فأي منتج Single مخزَّن بصيغة .name
    // كان يتسبب في Crash فعلي (Null check operator used on a null value).
    if (product.productType == 'ProductType.single' ||
        product.productType == 'single' ||
        product.productVariations == null ||
        product.productVariations!.isEmpty) {
      return product.stock.toString();
    }
    return product.productVariations!
        .fold<int>(0, (previousValue, element) => previousValue + element.stock)
        .toString();
  }

  /// Calculate Product Sold Quantity
  String getProductSoldQuantity(ProductEntity product) {
    // FIX: نفس مشكلة getProductStockTotal بالضبط.
    if (product.productType == 'ProductType.single' ||
        product.productType == 'single' ||
        product.productVariations == null ||
        product.productVariations!.isEmpty) {
      return product.soldQuantity.toString();
    }
    return product.productVariations!
        .fold<int>(0, (previousValue, element) => previousValue + element.soldQuantity)
        .toString();
  }

  /// Check Product Stock Status
  String getProductStockStatus(ProductEntity product) {
    return product.stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}