import 'package:dartz/dartz.dart';

import '../../../../common/errors/failure.dart';
import '../../data/models/product_category_model.dart';
import '../../data/models/product_model.dart';
import '../entities/product_category_entity.dart';
import '../entities/product_entity.dart';

abstract class ProductRepo {
  Future<Either<Failure, List<ProductEntity>>> fetchAllProducts();
  Future<Either<Failure, List<ProductCategoryEntity>>>
  fetchAllProductCategories(String productId);
  Future<Either<Failure, String>> createProduct(ProductModel Product);
  Future<Either<Failure, String>> createProductCategory(ProductCategoryModel ProductCategory);
  Future<Either<Failure, void>> editProduct(ProductModel Product);
   Future<Either<Failure, void>> deleteProduct(ProductModel product);
  Future<Either<Failure, void>> updateProductSpecificValue(
      String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> removeProductCategory(String productId, String categoryId) ;
}