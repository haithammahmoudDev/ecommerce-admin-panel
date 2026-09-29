import 'package:ecommerce_admin_pannal/features/customer/domain/repos/address_repo.dart';
import 'package:ecommerce_admin_pannal/utils/popups/exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../../order/domain/repos/user_repo.dart';

part 'customer_detail_state.dart';


class CustomerDetailCubit extends Cubit<CustomerDetailState> {
  final UserRepo _userRepo;
  final AddressRepo _addressRepo;

  CustomerDetailCubit({
    required this._userRepo,
    required this._addressRepo,
  })  : super(CustomerDetailState());

   Future<void> getCustomerOrders(BuildContext context) async {
     emit(state.copyWith(ordersLoading: true));

     if (state.customer.id.isNotEmpty) {
      final result = await _userRepo.fetchUserOrders(state.customer.id);

      result.fold(
             (failure) {
          emit(state.copyWith(
            ordersLoading: false,
            errorMessage: failure.message,
          ));
          TLoaders.errorSnackBar(title: 'Error Message',message: failure.message, context: context);
        },
             (orders) {
          emit(state.copyWith(
             allCustomerOrders: orders,
             filteredCustomerOrders: orders,
             selectedRows: List.generate(orders.length, (_) => false),
             ordersLoading: false,
          ));
        },
      );
    } else {
      emit(state.copyWith(ordersLoading: false));
    }
  }

  Future<void> getCustomerAddresses(BuildContext context) async {
    emit(state.copyWith(addressesLoading: true));

    if (state.customer.id.isNotEmpty) {
      final result = await _addressRepo.fetchUserAddresses(state.customer.id);

      result.fold(
            (failure) {
          emit(state.copyWith(
            addressesLoading: false,
            errorMessage: failure.message,
          ));
          TLoaders.errorSnackBar(title: 'Oh Snap!', message: failure.message, context: context
          );
        },
            (addresses) {
          final updatedCustomer = state.customer.copyWith(addresses: addresses);
          emit(state.copyWith(
            customer: updatedCustomer,
            addressesLoading: false,
          ));
        },
      );
    } else {
      emit(state.copyWith(addressesLoading: false));
    }
  }
  void updateCustomer(UserEntity user){
    emit(state.copyWith(customer: user));
  }
  void searchQuery(String query) {
    if (query.trim().isEmpty) {
      emit(state.copyWith(filteredCustomerOrders: state.allCustomerOrders));
      return;
    }

    final filtered = state.allCustomerOrders.where((order) {
      final matchesId = order.id.toLowerCase().contains(query.toLowerCase());
      final matchesDate = order.orderDate.toString().contains(query.toLowerCase());
      return matchesId || matchesDate;
    }).toList();

    emit(state.copyWith(filteredCustomerOrders: filtered));
  }

  void sortById(int columnIndex, bool ascending) {
     final sortedOrders = List<OrderEntity>.from(state.allCustomerOrders);
     sortedOrders.sort((a, b) {
      if (ascending) {
        return a.id.compareTo(b.id);
      } else {
        return b.id.compareTo(a.id);
      }
    });

    emit(state.copyWith(
      sortColumnIndex: columnIndex,
      sortAscending: ascending,
      allCustomerOrders: sortedOrders,
    ));
  }
}