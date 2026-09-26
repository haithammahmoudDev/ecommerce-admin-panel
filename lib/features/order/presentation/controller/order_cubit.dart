import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../utils/constants/enums.dart';

import '../../../../utils/popups/loaders.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repos/order_repo.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepo _orderRepository;

  OrderCubit(this._orderRepository) : super(const OrderState());

  /// Fetch all orders
  Future<void> fetchItems() async {
    emit(state.copyWith(status: OrderStatusEnum.loading));
    final result = await _orderRepository.getAllOrders();
    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: OrderStatusEnum.error,
            errorMessage: error.message,
          ),
        );
      },
      (items) {
        emit(
          state.copyWith(
            status: OrderStatusEnum.success,
            allItems: items,
            filteredItems: items,
            selectedRows: List<bool>.filled(items.length, false),
          ),
        );
      },
    );
  }


  Future<void> deleteOnConfirm(OrderEntity order, BuildContext context) async {
    emit(state.copyWith(status: OrderStatusEnum.loading));

    final result = await _orderRepository.deleteOrder(order.id);

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: OrderStatusEnum.error,
            errorMessage: error.toString(),
          ),
        );
        if (!context.mounted) return;
        TLoaders.errorSnackBar(
          title: 'Oh Snap!',
          message: error.toString(),
          context: context,
        );
      },
      (_) {
        final updatedAll = state.allItems
            .where((o) => o.id != order.id)
            .toList();
        final updatedFiltered = state.filteredItems
            .where((o) => o.id != order.id)
            .toList();
        emit(
          state.copyWith(
            status: OrderStatusEnum.success,
            allItems: updatedAll,
            filteredItems: updatedFiltered,
            selectedRows: List<bool>.filled(updatedFiltered.length, false),
          ),
        );
        removeItemFromLists(order);
        if (!context.mounted) return;
        TLoaders.successSnackBar(
          title: 'Item Deleted',
          message: 'Your Item has been Deleted',
          context: context,
        );
      },
    );
  }

  /// Change selected order status
  void selectOrderStatus(OrderStatus status) {
    emit(state.copyWith(selectedOrderStatus: status));
  }

  void toggleRowSelection(int index, bool? selected) {
    if (index < 0 || index >= state.selectedRows.length) return;

    final updated = List<bool>.from(state.selectedRows);
    updated[index] = selected ?? false;

    emit(state.copyWith(selectedRows: updated));
  }

  void removeItemFromLists(OrderEntity item) {
    final itemId = getItemId(item);
    final index = state.filteredItems.indexWhere((c) => getItemId(c) == itemId);

    final updatedAll = state.allItems
        .where((c) => getItemId(c) != itemId)
        .toList();
    final updatedFiltered = state.filteredItems
        .where((c) => getItemId(c) != itemId)
        .toList();

    final updatedSelected = List<bool>.from(state.selectedRows);
    if (index != -1 && index < updatedSelected.length) {
      updatedSelected.removeAt(index);
    }

    emit(
      state.copyWith(
        allItems: updatedAll,
        filteredItems: updatedFiltered,
        selectedRows: updatedSelected,
        status: OrderStatusEnum.success,
      ),
    );
  }

  void searchQuery(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredItems: state.allItems));
      return;
    }

    final filtered = state.allItems
        .where((item) => filterCondition(item, query))
        .toList();

    emit(state.copyWith(filteredItems: filtered));
  }

  /// 3. Filter Condition helper
  bool filterCondition(OrderEntity item, String query) {
    final lowerQuery = query.toLowerCase();
    return item.id.toLowerCase().contains(lowerQuery) ||
        item.totalAmount.toString().contains(lowerQuery);
  }

  String getItemId(OrderEntity item) => item.id;
  void sortById(int columnIndex, bool ascending) {
    sortByProperty(columnIndex, ascending, (item) => item.id.toLowerCase());
  }

  void sortByAmount(int columnIndex, bool ascending) {
    sortByProperty(columnIndex, ascending, (item) => item.totalAmount);
  }

  void sortByDate(int columnIndex, bool ascending) {
    sortByProperty(columnIndex, ascending, (item) => item.orderDate);
  }

  void sortByProperty(
    int columnIndex,
    bool ascending,
    Comparable Function(OrderEntity item) property,
  ) {
    final sorted = List<OrderEntity>.from(state.filteredItems);

    sorted.sort((a, b) {
      final aValue = property(a);
      final bValue = property(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    emit(
      state.copyWith(
        filteredItems: sorted,
        sortColumnIndex: columnIndex,
        sortAscending: ascending,
      ),
    );
  }

  Future<void> updateOrderStatus(OrderEntity order, OrderStatus newStatus) async {
    final updatedOrder = order.copyWith(status: newStatus);

    final result = await _orderRepository.updateOrderSpecificValue(order.id, {
      'status' : newStatus.toString(),
    });

    result.fold(
          (failure) {
        emit(state.copyWith(
          errorMessage: failure.message,
        ));
      },
          (_) {
        updateItemInLists(updatedOrder);
      },
    );
  }



void updateItemInLists(OrderEntity updatedItem) {
  final updatedId = getItemId(updatedItem);

  final updatedAll = state.allItems.map((item) {
    return getItemId(item) == updatedId ? updatedItem : item;
  }).toList();

  final updatedFiltered = state.filteredItems.map((item) {
    return getItemId(item) == updatedId ? updatedItem : item;
  }).toList();

  emit(state.copyWith(
    allItems: updatedAll,
    filteredItems: updatedFiltered,
    status: OrderStatusEnum.success,
  ));
}
}
