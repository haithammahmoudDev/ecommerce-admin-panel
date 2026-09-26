import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../common/errors/exceptions.dart';
import '../../../../common/errors/failure.dart';
import '../../../../common/network/firebase/database_services.dart';
import '../../../../common/preferences/save_user_by_hive.dart';
import '../../../order/data/models/user_model.dart';
import '../../../order/domain/entities/user_entity.dart';
import '../../domain/repos/profile_repo.dart';
import '../data_source/profile_datasource.dart';


class ProfileRepoImple implements ProfileRepo{
  final ProfileDatasource profileDatasource;
  final DatabaseServices _databaseServices;
  ProfileRepoImple({required this.profileDatasource, required this._databaseServices});
  Future<Either<Failure, UserEntity>> getUserData() async{
    try{
      final userData = await profileDatasource.getUserData();
      await UserRepository().saveUser(
          userData.toEntity());
      return right(userData.toEntity());
    }on ServerException catch (e){
      return left((ServerFailure(e.toString())));
    }catch (e){
      return left((ServerFailure(e.toString())));
    }
  }
  Future<Either<Failure, void>> updateUserData({required UserEntity user}) async{
    try{
      await profileDatasource.updateUser(UserModel.fromEntity(user));
      await UserRepository().updateUser(
        email: user.email,
        image: user.profilePicture,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
      );
      return const Right(null);
    }on ServerException catch (e){
      return left((ServerFailure(e.toString())));
    }catch (e){
      return left((ServerFailure(e.toString())));
    }
  }

  Future<Either<Failure, String>> uploadImagePic({required File file}) async{
    try{
      final ImagePic =  await profileDatasource.uploadImageProfile(file: file);
      await _databaseServices.updateData(path: 'users',
          docId: FirebaseAuth.instance.currentUser!.uid, data: {
            'profilePicture' : ImagePic,
          });
      final user = await profileDatasource.getUserData();
      await UserRepository().updateUser(
        email: user.email,
        image: ImagePic,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
      );
      return right(ImagePic);
    }on ServerException catch (e){
      return left((ServerFailure(e.toString())));
    }catch (e){
      return left((ServerFailure(e.toString())));
    }
  }

  Future<Either<Failure, void>> deleteAccount() async{
    try{
      await profileDatasource.deleteAccount();
      return const Right(null);
    }on ServerException catch (e){
      return left((ServerFailure(e.toString())));
    }catch (e){
      return left((ServerFailure(e.toString())));
    }
  }

  Future<Either<Failure, void>> reAuthenticateEmailAndPassword({required String email,
    required String password}) async{
    try{
      await profileDatasource.reAuthenticateEmailAndPassword(email: email,
          password: password);
      return const Right(null);
    }on ServerException catch (e){
      return left((ServerFailure(e.toString())));
    }catch (e){
      return left((ServerFailure(e.toString())));
    }
  }
}