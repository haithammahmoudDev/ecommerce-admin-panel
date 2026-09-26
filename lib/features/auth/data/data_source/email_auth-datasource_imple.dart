import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/network/firebase/auth_client.dart';
import '../../../order/data/models/user_model.dart';
import 'email_auth_datasource.dart';

class EmailAuthdatasourceImple implements EmailAuthDatasource{
  final AuthClient _authClient;
  EmailAuthdatasourceImple({required this._authClient});

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try{
      final UserCredential userCredential =
      await _authClient.signIn(email: email, password: password);
      final user = userCredential.user;
      if(user == null){
        throw AuthException('failed create new user, try again');
      }
      return UserModel.fromFirebaseUser(user);
    } on AuthException {
      rethrow;
    }
    on FirebaseAuthException catch(e){
      throw AuthException(e.toString());
    }catch (e){
      throw ServerException('error unexpected!');
    }

  }

  @override
  Future<UserModel> signUp(
      {required String userName,
        required String email,
        required String phoneNumber,
        required String password}) async{
 try{
   final UserCredential userCredential =
   await _authClient.signUp(email: email, password: password);
   final user = userCredential.user;
   if(user == null){
     throw AuthException('failed create new user, try again');
   }
   return UserModel.fromFirebaseUser(user);
  } on AuthException {
   rethrow;
 }
 on FirebaseAuthException catch(e){
   throw AuthException(e.toString());
 }catch (e){
  throw ServerException('error unexpected!');
 }

   }
}