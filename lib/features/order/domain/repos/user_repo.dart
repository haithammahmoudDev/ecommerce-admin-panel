import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import '../entities/order_entity.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, UserEntity>> getUserDetail(String id);
  Future<Either<Failure, void>> createUser({required UserEntity user});
  Future<Either<Failure, void>> updateSingleField(
      {required Map<String, dynamic> json});
  Future<Either<Failure, void>> deleteUser({required String id});
  Future<Either<Failure, List<OrderEntity>>> fetchUserOrders(
      String userId);
  Future<Either<Failure, UserEntity>> fetchAdminDetails();
}