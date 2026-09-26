import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/features/order/data/models/order_model.dart';
import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';

abstract class OrderRepo {
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, void>> createOrder({required OrderModel order});
  Future<Either<Failure, void>> updateOrderSpecificValue(String orderId, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteOrder(String orderId);
}