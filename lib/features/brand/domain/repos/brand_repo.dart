import 'package:dartz/dartz.dart';

import '../../../../common/errors/failure.dart';
import '../../data/models/brand_category.dart';
import '../../data/models/brand_model.dart';
import '../entities/brand_category_entity.dart';
import '../entities/brand_entity.dart';

abstract class BrandRepo {
  Future<Either<Failure, List<BrandEntity>>> fetchAllBrands();
  Future<Either<Failure, List<BrandCategoryEntity>>> fetchAllBrandCategories();
  Future<Either<Failure, List<BrandCategoryEntity>>> getCategoriesOfSpecificBrand(String brandId);
  Future<Either<Failure, String>> createBrand(BrandModel brand);
  Future<Either<Failure, String>> createBrandCategory(BrandCategoryModel brandCategory);
  Future<Either<Failure, void>> editBrand(BrandModel brand);
  Future<Either<Failure, void>> deleteBrand(String brandId);
  Future<Either<Failure, void>> deleteCategoryBrand(String categoryBrandId);
  Future<Either<Failure, void>> incrementProductsCount(String brandId, {required int by});

}