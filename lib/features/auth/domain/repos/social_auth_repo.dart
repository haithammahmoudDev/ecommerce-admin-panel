import 'package:dartz/dartz.dart';
import '../../../../common/errors/failure.dart';
import '../entities/user_entity.dart';

abstract interface class SocialAuthRepo {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
}