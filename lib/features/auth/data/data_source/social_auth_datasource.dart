import '../models/user_model.dart';

abstract interface class SocialAuthDatasource{
  Future<UserModel> signInWithGoogle();
}