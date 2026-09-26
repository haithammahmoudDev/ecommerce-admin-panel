import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/entities/category_entity.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/repos/category_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../../common/abstraction/base_data_table/base_data_table_cubit.dart';
import '../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../utils/popups/loaders.dart';
import '../create_category/create_category_state.dart';


class CategoryCubit extends BaseDataTableCubit<CategoryEntity> {
  final CategoryRepo categoryRepo;

  CategoryCubit({required this.categoryRepo});

  // === 1. Overrides المطلوب تنميتها من base_data_table_cubit ===

  @override
  String getItemId(CategoryEntity item) => item.id;

  @override
  bool filterCondition(CategoryEntity item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> fetchItems() async {
    return await categoryRepo.fetchCategoryData();
  }

  // === 2. الترتيب باستخدام sortByProperty من الكلاس الأب ===

  void sortByName(int columnIndex, bool ascending) {
    sortByProperty(
      columnIndex,
      ascending,
          (category) => category.name.toLowerCase(),
    );
  }

  void sortByParentName(int columnIndex, bool ascending) {
    sortByProperty(
      columnIndex,
      ascending,
          (category) {
        final parent = state.allItems.firstWhereOrNull((item) => item.id == category.parentId);
        return parent?.name.toLowerCase() ?? '';
      },
    );
  }

  // === 3. عمليات الحذف الخاصة بـ CategoryRepo ===

  Future<void> deleteOnConfirm(CategoryEntity category, BuildContext context) async {
    emit(state.copyWith(status: DataTableStatus.loading));

    final result = await categoryRepo.deleteCategory(category.id);

    result.fold(
          (error) {
        emit(state.copyWith(status: DataTableStatus.error));
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString(), context: context);
      },
          (_) {
        removeItemFromLists(category);
        TLoaders.successSnackBar(
          title: 'Item Deleted',
          message: 'Your Item has been Deleted',
          context: context,
        );
      },
    );
  }

}