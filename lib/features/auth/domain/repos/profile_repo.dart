import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../common/errors/failure.dart';
import '../../../order/domain/entities/user_entity.dart';

abstract class ProfileRepo {
  Future<Either<Failure, UserEntity>> getUserData();
  Future<Either<Failure, void>> updateUserData({required UserEntity user});
  Future<Either<Failure, String>> uploadImagePic({required File file});
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, void>> reAuthenticateEmailAndPassword({required String email,
    required String password});
}