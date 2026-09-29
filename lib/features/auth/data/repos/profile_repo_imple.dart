import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/errors/failure.dart';
import '../../../../common/local_storage/local_storage_service.dart';
import '../../../../common/network/firebase/database_services.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repos/profile_repo.dart';
import '../data_source/profile_datasource.dart';


class ProfileRepoImple implements ProfileRepo{
  final ProfileDatasource profileDatasource;
  final DatabaseServices _databaseServices;
  ProfileRepoImple({required this.profileDatasource, required this._databaseServices});
  Future<Either<Failure, UserEntity>> getUserData() async{
    try{
      final userData = await profileDatasource.getUserData();
      LocalStorageService.userRepo.saveData(userData);
      return right(userData.toEntity());
    }on ServerException catch (e){
      return left((ServerFailure(e.toString())));
    }catch (e){
      return left((ServerFailure(e.toString())));
    }
  }
  @override
  Future<Either<Failure, void>> updateUserData({required UserEntity user}) async{
    try{
      await profileDatasource.updateUser(
        UserModel.fromEntity(user).copyWith(
          fullName: user.fullName,
          phoneNumber: user.phoneNumber,
         ),
      );
      await LocalStorageService.userRepo.updateData((currentUser) {
        return currentUser.copyWith(
          fullName: user.fullName,
          phoneNumber: user.phoneNumber,
          profilePicture: user.profilePicture,
          email: user.email,
          updatedAt: DateTime.now(),
        );
      });
      return const Right(null);
    }on ServerException catch (e){
      return left((ServerFailure(e.toString())));
    }catch (e){
      return left((ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfilePictureUrl({required String imageUrl}) async {
    try {
       await _databaseServices.updateData(
        path: 'users',
        docId: FirebaseAuth.instance.currentUser!.uid,
        data: {
          'ProfilePicture': imageUrl,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

       await LocalStorageService.userRepo.updateData((currentUser) {
        return currentUser.copyWith(
          profilePicture: imageUrl,
          updatedAt: DateTime.now(),
        );
      });

      return right(imageUrl);
    } on ServerException catch (e) {
      return left(ServerFailure(e.toString()));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
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

  @override
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