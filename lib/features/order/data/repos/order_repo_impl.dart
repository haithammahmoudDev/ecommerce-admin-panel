import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/common/network/firebase/database_services.dart';
import 'package:ecommerce_admin_pannal/features/order/data/models/order_model.dart';
import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';
import '../../domain/repos/order_repo.dart';

class OrderRepoImpl implements OrderRepo{
  final DatabaseServices _databaseServices;
  OrderRepoImpl({required this._databaseServices});

  @override
  Future<Either<Failure, void>> createOrder({required OrderModel order}) async{
   try{
     await _databaseServices.addData(data: order.toJson(), path: 'Orders');
     return const Right(null);
   }catch(e) {
     return left(ServerFailure(e.toString()));
   }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async{
    try{
      final querySnapshot = await FirebaseFirestore.instance.collection('Orders').get();
      final List<OrderEntity> orderList =  querySnapshot.docs
          .map((doc) =>
          OrderModel.fromFirebaseData(doc.data(),doc.id).toEntity())
          .toList();
      return right(orderList);
    }catch(e) {
      return left(ServerFailure(e.toString()));
    }
  }


  Future<Either<Failure, void>> updateOrderSpecificValue(String orderId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('Orders').doc(orderId).update(data);
      return const Right(null);
    }catch(e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(String orderId) async{
    try {
      await _databaseServices.deleteData(path: 'Orders', docId: orderId);
      return const Right(null);
    }catch(e) {
      return left(ServerFailure(e.toString()));
    }
  }

}