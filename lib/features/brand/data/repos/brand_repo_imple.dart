import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/common/network/firebase/database_services.dart';
import 'package:ecommerce_admin_pannal/features/brand/data/models/brand_model.dart';
import 'package:ecommerce_admin_pannal/features/brand/domain/entities/brand_entity.dart';
import '../../domain/entities/brand_category_entity.dart';
import '../../domain/repos/brand_repo.dart';
import '../models/brand_category.dart';

class BrandRepoImpl implements BrandRepo {
  final DatabaseServices _databaseServices;
  BrandRepoImpl({required this._databaseServices});

  @override
  Future<Either<Failure, List<BrandEntity>>> fetchAllBrands() async {
    try {
      final List<Map<String, dynamic>> data = await _databaseServices.getData(path: 'Brands');
      final List<BrandEntity> brandList =
      data.map((e) => BrandModel.fromFirebaseData(e)).map((e) => e.toEntity()).toList();
      return right(brandList);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BrandCategoryEntity>>> fetchAllBrandCategories() async {
    try {
      final List<Map<String, dynamic>> data = await _databaseServices.getData(path: 'BrandCategory');
      final List<BrandCategoryEntity> brandCategoryList =
      data.map((e) => BrandCategoryModel.fromFirebaseData(e)).map((e) => e.toEntity()).toList();
      return right(brandCategoryList);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<BrandCategoryEntity>>> getCategoriesOfSpecificBrand(String brandId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
          .collection('BrandCategory')
          .where('BrandId', isEqualTo: brandId)
          .get();
      final List<BrandCategoryEntity> brandCategoryList = data.docs
          .map((doc) => BrandCategoryModel.fromFirebaseData(doc.data()))
          .map((model) => model.toEntity())
          .toList();
      return right(brandCategoryList);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createBrand(BrandModel brand) async {
    try {
      final String idBrand = await _databaseServices.addDataAndGetId(path: 'Brands', data: brand.toJson());
      return right(idBrand);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createBrandCategory(BrandCategoryModel brandCategory) async {
    try {
      final String idBrandCategory = await _databaseServices.addDataAndGetId(
        path: 'BrandCategory',
        data: brandCategory.toJson(),
      );
      return right(idBrandCategory);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editBrand(BrandModel brand) async {
    try {
      await _databaseServices.setData(path: 'Brands', docId: brand.id, data: brand.toJson());
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBrand(String brandId) async {
    try {
      await _databaseServices.deleteData(path: 'Brands', docId: brandId);
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategoryBrand(String categoryBrandId) async {
    try {
      await _databaseServices.deleteData(path: 'BrandCategory', docId: categoryBrandId);
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> incrementProductsCount(String brandId, {required int by}) async {
    try {
      await FirebaseFirestore.instance.collection('Brands').doc(brandId).update({
        'productsCount': FieldValue.increment(by),
      });
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}