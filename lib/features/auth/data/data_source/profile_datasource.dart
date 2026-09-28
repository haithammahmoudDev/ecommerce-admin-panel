import 'dart:io';
import '../models/user_model.dart';

abstract class ProfileDatasource {
  Future<UserModel> getUserData();
  Future<void> updateUser(UserModel user);
  Future<void> logOut();
  Future<String> uploadImageProfile({required File file});
  Future<void> deleteAccount();
  Future<void> reAuthenticateEmailAndPassword(
      {
        required String email,
        required String password,
      }
      );
}