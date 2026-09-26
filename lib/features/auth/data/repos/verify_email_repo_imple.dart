import 'package:dartz/dartz.dart';
import '../../../../../common/errors/exceptions.dart';
import '../../../../common/errors/failure.dart';
import '../../domain/repos/verify_email_repo.dart';
import '../data_source/verify_email_datasource.dart';

class VerifyEmailRepoImple implements VerifyEmailRepo{
  final VerifyEmailDatasource _verifyEmailDatasource;
  VerifyEmailRepoImple({required this._verifyEmailDatasource});
  @override
  Future<Either<Failure, void>> sendEmailVaerification() async {
    try{
      await _verifyEmailDatasource.sendEmailVerification();
      return const Right(null);
    }on AuthException catch (e){
      return left(AuthFailure(e.toString()));
    } on ServerException catch (e){
      return  left(ServerFailure(e.toString()));
    }catch(e){
      return  left(ServerFailure(e.toString()));
    }
  }
}