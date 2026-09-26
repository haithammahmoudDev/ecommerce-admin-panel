import 'package:ecommerce_admin_pannal/features/auth/data/data_source/verify_email_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/network/firebase/auth_client.dart';

class VerifyEmailDatasourceImple implements VerifyEmailDatasource{
  final AuthClient _authClient;
  VerifyEmailDatasourceImple({required this._authClient});
  @override
  Future<void> sendEmailVerification() async{
   try{
   await _authClient.sendEmailVerification();
   } on FirebaseAuthException catch(e){
      throw AuthException(e.toString());
   }catch(e){
     throw ServerException(e.toString());
   }
  }

}