import 'package:dartz/dartz.dart';

import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/features/banner/domain/entities/banner_entity.dart';
import 'package:ecommerce_admin_pannal/features/banner/domain/repos/banner_repo.dart';
import 'package:flutter/cupertino.dart';

import '../../../../common/abstraction/base_data_table/base_data_table_cubit.dart';
import '../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../brand/domain/entities/brand_entity.dart';
import '../../../brand/domain/repos/brand_repo.dart';
import '../../../categories/presentation/controller/category/category_cubit.dart';

class BannerCubit extends BaseDataTableCubit<BannerEntity> {
  final BannerRepo bannerRepo;

  BannerCubit({
    required this.bannerRepo,
   });

  @override
  String getItemId(BannerEntity item) => item.id;

  @override
  bool filterCondition(BannerEntity item, String query) {
    return item.targetScreen.toLowerCase().contains(query.toLowerCase());
  }

@override
Future<Either<Failure, List<BannerEntity>>> fetchItems() async{
  return await bannerRepo.getAllBanner();

}

  Future<void> deleteOnConfirm(BannerEntity banner, BuildContext context) async {
    emit(state.copyWith(status: DataTableStatus.loading));

    final result = await bannerRepo.deleteBanner(banner.id);

    result.fold(
          (error) {
        emit(state.copyWith(status: DataTableStatus.error, errorMessage: error.toString()));
        if (!context.mounted) return;
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString(), context: context);
      },
          (_) {
            removeItemFromLists(banner);
        if (!context.mounted) return;
        TLoaders.successSnackBar(
          title: 'Item Deleted',
          message: 'Your Item has been Deleted',
          context: context,
        );
      },
    );
  }

  String formatRoute(String route) {
    if (route.isEmpty) return '';
    String formatted = route.substring(1);
    formatted = formatted[0].toUpperCase() + formatted.substring(1);
    return formatted;
  }




  void sortByName(int columnIndex, bool ascending) {
    sortByProperty(
      columnIndex,
      ascending,
          (banner) => banner.targetScreen.toLowerCase(),
    );
  }

}
