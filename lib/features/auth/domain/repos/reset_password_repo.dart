import 'package:dartz/dartz.dart';
import '../../../../common/errors/failure.dart';

abstract interface class ResetPasswordRepo {
  Future<Either<Failure, void>>sendPasswordResetEmail({required String email});
}