part of 'order_detail_cubit.dart';

enum OrderDetailStatus { initial, loading, success, failure }

class OrderDetailState extends Equatable {
  final OrderDetailStatus status;
  final OrderEntity order;
  final UserEntity customer;
  final String? errorMessage;

  OrderDetailState({
    this.status = OrderDetailStatus.initial,
    OrderEntity? order,
    UserEntity? customer,
    this.errorMessage,
  })  : order = order ?? OrderEntity.empty(),
        customer = customer ?? UserEntity.empty;

  OrderDetailState copyWith({
    OrderDetailStatus? status,
    OrderEntity? order,
    UserEntity? customer,
    String? errorMessage,
  }) {
    return OrderDetailState(
      status: status ?? this.status,
      order: order ?? this.order,
      customer: customer ?? this.customer,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, order, customer, errorMessage];
}