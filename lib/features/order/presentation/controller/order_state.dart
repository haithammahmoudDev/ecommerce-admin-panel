import 'package:equatable/equatable.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../domain/entities/order_entity.dart';

enum OrderStatusEnum { initial, loading, success, error }

class OrderState extends Equatable {
  final List<OrderEntity> allItems;
  final List<OrderEntity> filteredItems;
  final OrderStatusEnum status;
  final OrderStatus selectedOrderStatus;
  final int sortColumnIndex;
  final bool sortAscending;
  final List<bool> selectedRows;
  final String? errorMessage;

  const OrderState({
    this.allItems = const [],
    this.filteredItems = const [],
    this.status = OrderStatusEnum.initial,
    this.selectedOrderStatus = OrderStatus.delivered,
    this.sortColumnIndex = 0,
    this.sortAscending = true,
    this.selectedRows = const [],
    this.errorMessage,
   });

  OrderState copyWith({
    List<OrderEntity>? allItems,
    List<OrderEntity>? filteredItems,
    OrderStatusEnum? status,
    OrderStatus? selectedOrderStatus,
    int? sortColumnIndex,
    bool? sortAscending,
    List<bool>? selectedRows,
    String? errorMessage,
   }) {
    return OrderState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      status: status ?? this.status,
      selectedOrderStatus: selectedOrderStatus ?? this.selectedOrderStatus,
      sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedRows: selectedRows ?? this.selectedRows,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    allItems,
    filteredItems,
    status,
    selectedOrderStatus,
    sortColumnIndex,
    sortAscending,
    selectedRows,
    errorMessage,
  ];
}