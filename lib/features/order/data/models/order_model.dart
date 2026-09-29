import '../../../../utils/constants/enums.dart';
import '../../domain/entities/order_entity.dart';
import 'address_model.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String docId;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final double shippingCost;
  final double taxCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? shippingAddress;
  final AddressModel? billingAddress;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;
  final bool billingAddressSameAsShipping;

  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxCost,
    required this.orderDate,
    this.paymentMethod = 'Cash on Delivery',
    this.billingAddress,
    this.shippingAddress,
    this.deliveryDate,
    this.billingAddressSameAsShipping = true,
  });

  factory OrderModel.fromFirebaseData(Map<String, dynamic> json, String? docId) {
    return OrderModel(
      id: docId ?? json['id'] ?? '',
      docId: json['documentId'] ?? '',
      userId: json['userId'] ?? '',
      status: OrderStatus.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0.0,
      taxCost: (json['taxCost'] as num?)?.toDouble() ?? 0.0,
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      paymentMethod: json['paymentMethod'] ?? 'Cash on Delivery',
      shippingAddress: json['shippingAddress'] != null
          ? AddressModel.fromJson(json['shippingAddress'] as Map<String, dynamic>)
          : null,
      billingAddress: json['billingAddress'] != null
          ? AddressModel.fromJson(json['billingAddress'] as Map<String, dynamic>)
          : null,
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      billingAddressSameAsShipping: json['billingAddressSameAsShipping'] ?? true,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      docId: entity.docId,
      userId: entity.userId,
      status: entity.status,
      totalAmount: entity.totalAmount,
      shippingCost: entity.shippingCost,
      taxCost: entity.taxCost,
      orderDate: entity.orderDate,
      paymentMethod: entity.paymentMethod,
      shippingAddress: entity.shippingAddress != null
          ? AddressModel.fromEntity(entity.shippingAddress!)
          : null,
      billingAddress: entity.billingAddress != null
          ? AddressModel.fromEntity(entity.billingAddress!)
          : null,
      deliveryDate: entity.deliveryDate,
      items: entity.items.map((item) => CartItemModel.fromEntity(item)).toList(),
      billingAddressSameAsShipping: entity.billingAddressSameAsShipping,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'orderDate': orderDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'billingAddress': billingAddress?.toJson(),
      'shippingAddress': shippingAddress?.toJson(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'billingAddressSameAsShipping': billingAddressSameAsShipping,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      docId: docId,
      userId: userId,
      status: status,
      totalAmount: totalAmount,
      shippingCost: shippingCost,
      taxCost: taxCost,
      orderDate: orderDate,
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress?.toEntity(),
      billingAddress: billingAddress?.toEntity(),
      deliveryDate: deliveryDate,
      items: items.map((item) => item.toEntity()).toList(),
      billingAddressSameAsShipping: billingAddressSameAsShipping,
    );
  }
}