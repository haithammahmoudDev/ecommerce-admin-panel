import 'package:dartz/dartz.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/errors/failure.dart';
import '../../../../common/network/firebase/database_services.dart';
import '../../../../common/preferences/save_user_by_hive.dart';
import '../../../order/data/models/user_model.dart';
import '../../../order/domain/entities/user_entity.dart';
import '../../domain/repos/social_auth_repo.dart';
import '../data_source/social_auth_datasource.dart';

class SocialAuthRepoImple implements SocialAuthRepo{
  final SocialAuthDatasource _socialAuthDatasource;
  final DatabaseServices _databaseServices;
  SocialAuthRepoImple({required this._socialAuthDatasource, required this._databaseServices});


  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async{
    try{
      final UserModel user = await _socialAuthDatasource.signInWithGoogle();
      await _databaseServices.setData(path: 'users',
          docId: user.id, data: user.toJson());
      await UserRepository()
          .saveUser(user.toEntity());
      return right(user.toEntity());
    }on AuthException catch(e){
     return left(AuthFailure(e.toString()));
    }on ServerException catch(e){
      return left(ServerFailure(e.toString()));
    }catch(e){
      return left(ServerFailure(e.toString()));
    }
  }}