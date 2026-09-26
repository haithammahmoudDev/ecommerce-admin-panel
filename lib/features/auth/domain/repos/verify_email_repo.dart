import 'package:dartz/dartz.dart';
import '../../../../common/errors/failure.dart';

abstract interface class VerifyEmailRepo {
  Future<Either<Failure, void>> sendEmailVaerification();
}