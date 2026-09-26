import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../../../../common/abstraction/base_data_table/base_data_table_cubit.dart';
import '../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../common/errors/failure.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../order/domain/entities/user_entity.dart';
import '../../../order/domain/repos/user_repo.dart';


class CustomerCubit extends BaseDataTableCubit<UserEntity> {
  final UserRepo _userRepo;

  CustomerCubit({required UserRepo userRepo})
      : _userRepo = userRepo,
        super();

  /// جلب كافة المستخدمين
  @override
  Future<Either<Failure, List<UserEntity>>> fetchItems() async {
    return await _userRepo.getAllUsers();
  }

  /// تحديد المعرف الفريد للمستخدم
  @override
  String getItemId(UserEntity item) => item.id;

  /// شرط تصفية البحث حسب الاسم والبريد الإلكتروني
  @override
  bool filterCondition(UserEntity item, String query) {
    final lowerQuery = query.toLowerCase();
    return item.fullName.toLowerCase().contains(lowerQuery) ||
        item.email.toLowerCase().contains(lowerQuery);
  }

  /// فرز القائمة حسب الاسم الكامل
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (user) => user.fullName.toLowerCase(),
    );
  }

  Future<void> deleteOnConfirm(UserEntity user, BuildContext context) async {
    emit(state.copyWith(status: DataTableStatus.loading));

    final result = await _userRepo.deleteUser(id: user.id);

    result.fold(
          (error) {
        emit(state.copyWith(status: DataTableStatus.error));
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.message, context: context);
      },
          (_) {
        removeItemFromLists(user);
        TLoaders.successSnackBar(
          title: 'Item Deleted',
          message: 'Your Item has been Deleted',
          context: context,
        );
      },
    );
  }
}