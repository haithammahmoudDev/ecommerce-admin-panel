import 'package:dartz/dartz.dart';
import '../../../../common/errors/failure.dart';
import '../entities/user_entity.dart';

abstract class ProfileRepo {
  Future<Either<Failure, UserEntity>> getUserData();
  Future<Either<Failure, void>> updateUserData({required UserEntity user});
  Future<Either<Failure, String>> updateProfilePictureUrl({required String imageUrl});
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, void>> reAuthenticateEmailAndPassword({required String email,
    required String password});
}