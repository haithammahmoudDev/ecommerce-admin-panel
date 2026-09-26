import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/features/categories/data/models/category_model.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/entities/category_entity.dart';

 abstract interface class CategoryRepo {
  Future<Either<Failure, List<CategoryEntity>>> fetchCategoryData();
  Future<Either<Failure, void>> deleteCategory(String categoryId);
  Future<Either<Failure, String>> createCategory({required CategoryModel category});
  Future<Either<Failure, void>> editCategory({required CategoryModel category});
 }