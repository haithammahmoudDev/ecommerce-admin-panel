import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/entities/category_entity.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../common/abstraction/base_data_table/base_data_table_cubit.dart';
import '../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../utils/popups/loaders.dart';
import '../../domain/entities/brand_category_entity.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/repos/brand_repo.dart';

class BrandCubit extends BaseDataTableCubit<BrandEntity> {
  final BrandRepo brandRepo;
  final CategoryCubit categoryCubit;

  BrandCubit({
    required this.brandRepo,
    required this.categoryCubit,
  });

  @override
  String getItemId(BrandEntity item) => item.id;

  @override
  bool filterCondition(BrandEntity item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> fetchItems() async {
    Failure? failure;

    List<BrandEntity> fetchedBrands = [];
    final brandsResult = await brandRepo.fetchAllBrands();
    brandsResult.fold((l) => failure = l, (r) => fetchedBrands = r);
    if (failure != null) return Left(failure!);

    List<BrandCategoryEntity> fetchedBrandCategories = [];
    final brandCategoriesResult = await brandRepo.fetchAllBrandCategories();
    brandCategoriesResult.fold((l) => failure = l, (r) => fetchedBrandCategories = r);
    if (failure != null) return Left(failure!);

    if (categoryCubit.state.allItems.isEmpty) {
      await categoryCubit.fetchData();
    }
    final List<CategoryEntity> allCategories = categoryCubit.state.allItems;

     final List<BrandEntity> updatedBrands = [];

     for (final brand in fetchedBrands) {
      final categoryIds = fetchedBrandCategories
          .where((bc) => bc.brandId == brand.id)
          .map((bc) => bc.categoryId)
          .toList();

      final brandCategories = allCategories
          .where((category) => categoryIds.contains(category.id))
          .toList();

       updatedBrands.add(brand.copyWith(brandCategories: brandCategories));
    }

     return Right(updatedBrands);
  }

  void sortByName(int columnIndex, bool ascending) {
    sortByProperty(
      columnIndex,
      ascending,
          (brand) => brand.name.toLowerCase(),
    );
  }

  Future<void> deleteOnConfirm(BrandEntity brand, BuildContext context) async {
    emit(state.copyWith(status: DataTableStatus.loading));

    final result = await brandRepo.deleteBrand(brand.id);

    result.fold(
          (error) {
        emit(state.copyWith(status: DataTableStatus.error, errorMessage: error.toString()));
        if (!context.mounted) return;
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString(), context: context);
      },
          (_) {
        removeItemFromLists(brand);
        if (!context.mounted) return;
        TLoaders.successSnackBar(
          title: 'Item Deleted',
          message: 'Your Item has been Deleted',
          context: context,
        );
      },
    );
  }
}