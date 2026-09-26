import 'package:bloc/bloc.dart';
 import 'package:ecommerce_admin_pannal/utils/popups/exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:universal_html/html.dart';

import '../../../../../common/preferences/save_user_by_hive.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repos/user_repo.dart';

part 'order_detail_state.dart';


class OrderDetailCubit extends Cubit<OrderDetailState> {
  final UserRepo _userRepository;

  OrderDetailCubit({required this._userRepository}) : super(OrderDetailState());


  /// Fetch user details for the current order
  Future<void> getCustomerOfCurrentOrder(BuildContext context) async {
    emit(state.copyWith(status: OrderDetailStatus.loading));
      final result = await _userRepository.getUserDetail(state.order.userId);
      result.fold((failure){
        emit(state.copyWith(
          status: OrderDetailStatus.failure,
          errorMessage: failure.message,
        ));
        TLoaders.errorSnackBar(title: 'Error Message',message: failure.message, context: context);
      }, (user){
        emit(state.copyWith(
          status: OrderDetailStatus.success,
          customer: user,
        ));
      });
  }

  void updateOrder(OrderEntity order){
    emit(state.copyWith(order: order));
  }
}