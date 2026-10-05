import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/features/categories/data/models/category_model.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/entities/category_entity.dart';
import '../../../../common/network/firebase/database_services.dart';
import '../../domain/repos/category_repo.dart';

class CategoryRepoImpl implements CategoryRepo {
  final DatabaseServices _databaseServices;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CategoryRepoImpl({required this._databaseServices});

  @override
  Future<Either<Failure, List<CategoryEntity>>> fetchCategoryData() async {
    try {
      final List<Map<String, dynamic>> data = await _databaseServices.getData(
          path: 'categories');
      final List<CategoryEntity> categoryList =
      data.map((e) => CategoryModel.fromFirebaseJson(e)).map((e) =>
          e.toEntity()).toList();
      return right(categoryList);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String categoryId) async {
    try {
      final batch = _db.batch();

       batch.delete(_db.collection('categories').doc(categoryId));

       final subCategoriesSnapshot = await _db
          .collection('categories')
          .where('parentId', isEqualTo: categoryId)
          .get();
      for (final doc in subCategoriesSnapshot.docs) {
        batch.delete(doc.reference);
      }

       final productLinksSnapshot = await _db
          .collection('ProductCategory')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      for (final doc in productLinksSnapshot.docs) {
        batch.delete(doc.reference);
      }

       final brandLinksSnapshot = await _db
          .collection('BrandCategory')
          .where('CategoryId', isEqualTo: categoryId)
          .get();
      for (final doc in brandLinksSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createCategory({required CategoryModel category}) async{
    try {
      final String idCategory = await _databaseServices.addDataAndGetId(path: 'categories', data: category.toJson());
      return Right(idCategory);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editCategory({required CategoryModel category}) async{
    try {
      await _databaseServices.setData(path: 'categories', docId: category.id, data: category.toJson());
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}