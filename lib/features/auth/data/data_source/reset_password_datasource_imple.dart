import 'package:ecommerce_admin_pannal/features/auth/data/data_source/reset_password_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/network/firebase/auth_client.dart';

class ResetPasswordDatasourceImple implements ResetPasswordDatasource{
  final AuthClient _authClient;
  ResetPasswordDatasourceImple({required this._authClient});
  @override
  sendPasswordResetEmail({required String email}) async{
   try{
     await _authClient.sendPasswordResetEmail(email: email);
   }on FirebaseAuthException catch(e){
     throw AuthException(e.toString());
   }catch (e){
     throw ServerException(e.toString());
   }
  }
}