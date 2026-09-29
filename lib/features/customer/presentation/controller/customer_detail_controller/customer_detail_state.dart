part of 'customer_detail_cubit.dart';

class CustomerDetailState extends Equatable {
  final UserEntity customer;
  final List<OrderEntity> allCustomerOrders;
  final List<OrderEntity> filteredCustomerOrders;
  final bool ordersLoading;
  final bool addressesLoading;
  final int sortColumnIndex;
  final bool sortAscending;
  final List<bool> selectedRows;
  final String? errorMessage;

  const CustomerDetailState({
    this.customer = UserEntity.empty,
    this.allCustomerOrders = const [],
    this.filteredCustomerOrders = const [],
    this.ordersLoading = true,
    this.addressesLoading = true,
    this.sortColumnIndex = 1,
    this.sortAscending = true,
    this.selectedRows = const [],
    this.errorMessage,
  });

  CustomerDetailState copyWith({
    UserEntity? customer,
    List<OrderEntity>? allCustomerOrders,
    List<OrderEntity>? filteredCustomerOrders,
    bool? ordersLoading,
    bool? addressesLoading,
    int? sortColumnIndex,
    bool? sortAscending,
    List<bool>? selectedRows,
    String? errorMessage,
  }) {
    return CustomerDetailState(
      customer: customer ?? this.customer,
      allCustomerOrders: allCustomerOrders ?? this.allCustomerOrders,
      filteredCustomerOrders:
      filteredCustomerOrders ?? this.filteredCustomerOrders,
      ordersLoading: ordersLoading ?? this.ordersLoading,
      addressesLoading: addressesLoading ?? this.addressesLoading,
      sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedRows: selectedRows ?? this.selectedRows,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    customer,
    allCustomerOrders,
    filteredCustomerOrders,
    ordersLoading,
    addressesLoading,
    sortColumnIndex,
    sortAscending,
    selectedRows,
    errorMessage,
  ];
}