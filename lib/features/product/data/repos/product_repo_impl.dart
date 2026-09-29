import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/features/product/data/models/product_category_model.dart';
import 'package:ecommerce_admin_pannal/features/product/data/models/product_model.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_category_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/repos/product_repo.dart';
import '../../../../common/network/firebase/database_services.dart';

class ProductRepoImpl implements ProductRepo {
  final DatabaseServices _databaseServices;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ProductRepoImpl({required this._databaseServices});

  @override
  Future<Either<Failure, String>> createProduct(ProductModel product) async {
    try {
      final idProduct = await _databaseServices.addDataAndGetId(
        path: 'Products',
        data: product.toJson(),
      );
      return right(idProduct);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createProductCategory(
      ProductCategoryModel productCategory) async {
    try {
      final idCategory = await _databaseServices.addDataAndGetId(
        path: 'ProductCategory',
        data: productCategory.toJson(),
      );
      return right(idCategory);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }


   @override
  Future<Either<Failure, void>> deleteProduct(ProductModel product) async {
    try {
      await _db.runTransaction((transaction) async {
        final productRef = _db.collection("Products").doc(product.id);
        final productSnap = await transaction.get(productRef);

        if (!productSnap.exists) {
          throw Exception("Product not found");
        }

         final productCategoriesSnapshot = await _db
            .collection('ProductCategory')
            .where('productId', isEqualTo: product.id)
            .get();

        final productCategories = productCategoriesSnapshot.docs
            .map((doc) => ProductCategoryModel.fromFirebaseJson(doc.data()))
            .toList();

        if (productCategories.isNotEmpty) {
          for (var doc in productCategoriesSnapshot.docs) {
            transaction.delete(doc.reference);
          }
        }

         transaction.delete(productRef);
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editProduct(ProductModel product) async {
    try {
      await _databaseServices.setData(
        path: 'Products',
        docId: product.id,
        data: product.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductCategoryEntity>>>
  fetchAllProductCategories(String productId) async {
    try {
      final querySnapshot = await _db
          .collection('ProductCategory')
          .where('productId', isEqualTo: productId)
          .get();

      final list = querySnapshot.docs
          .map((doc) => ProductCategoryModel.fromFirebaseJson(doc.data()))
          .map((model) => model.toEntity())
          .toList();

      return Right(list);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchAllProducts() async {
    try {
      final querySnapshot = await _db.collection('Products').get();
      final list = querySnapshot.docs
          .map((doc) =>
          ProductModel.fromFirebaseData(doc.data(),doc.id).toEntity())
          .toList();
      return right(list);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

     @override
    Future<Either<Failure, void>> updateProductSpecificValue(
        String id, Map<String, dynamic> data) async {
      try {
        await _db.collection('Products').doc(id).update(data);
        return const Right(null);
      } catch(e) {
        return left(ServerFailure(e.toString()));
      }
    }

  @override
  Future<Either<Failure, void>> removeProductCategory(String productId, String categoryId) async {
    try {
      final result =
      await _db.collection("ProductCategory").where('productId', isEqualTo: productId).where('categoryId', isEqualTo: categoryId).get();

      for (final doc in result.docs) {
        await doc.reference.delete();
      }
      return const Right(null);
    } catch(e) {
      return left(ServerFailure(e.toString()));
    }
  }
}