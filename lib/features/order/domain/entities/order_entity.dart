import '../../../../utils/constants/enums.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../data/models/order_model.dart';
import 'address_entity.dart';
import 'cart_item_entity.dart';

class OrderEntity {
  final String id;
  final String docId;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final double shippingCost;
  final double taxCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressEntity? shippingAddress;
  final AddressEntity? billingAddress;
  final DateTime? deliveryDate;
  final List<CartItemEntity> items;
  final bool billingAddressSameAsShipping;

  OrderEntity({
    required this.id,
    required this.docId,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxCost,
    required this.orderDate,
    required this.paymentMethod,
    this.shippingAddress,
    this.billingAddress,
    this.deliveryDate,
    required this.items,
    required this.billingAddressSameAsShipping,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate =>
      deliveryDate != null ? THelperFunctions.getFormattedDate(deliveryDate!) : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
      ? 'Shipment on the way'
      : 'Processing';

  OrderEntity copyWith({
    String? id,
    String? docId,
    String? userId,
    OrderStatus? status,
    double? totalAmount,
    double? shippingCost,
    double? taxCost,
    DateTime? orderDate,
    String? paymentMethod,
    AddressEntity? shippingAddress,
    AddressEntity? billingAddress,
    DateTime? deliveryDate,
    List<CartItemEntity>? items,
    bool? billingAddressSameAsShipping,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingCost: shippingCost ?? this.shippingCost,
      taxCost: taxCost ?? this.taxCost,
      orderDate: orderDate ?? this.orderDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      items: items ?? this.items,
      billingAddressSameAsShipping:
      billingAddressSameAsShipping ?? this.billingAddressSameAsShipping,
    );
  }

  // Static function to create an empty user model.
  static OrderEntity empty() => OrderEntity(
    id: '',
    docId: '',
    userId: '',
    status: OrderStatus.pending,
    totalAmount: 0,
    shippingCost: 0,
    taxCost: 0,
    orderDate: DateTime.now(),
    paymentMethod: '',
    items: [],
    billingAddressSameAsShipping: true,
  );

  // Convert OrderEntity back into a Data OrderModel
  OrderModel toModel() {
    return OrderModel(
      id: id,
      docId: docId,
      userId: userId,
      status: status,
      items: items.map((item) => item.toModel()).toList(),
      totalAmount: totalAmount,
      shippingCost: shippingCost,
      taxCost: taxCost,
      orderDate: orderDate,
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress?.toModel(),
      billingAddress: billingAddress?.toModel(),
      deliveryDate: deliveryDate,
      billingAddressSameAsShipping: billingAddressSameAsShipping,
    );
  }

  // أضف هذا السطر داخل كلاس OrderModel
 }