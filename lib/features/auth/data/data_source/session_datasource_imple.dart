import 'package:ecommerce_admin_pannal/features/auth/data/data_source/session_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../common/errors/exceptions.dart';
import '../../../../common/network/firebase/auth_client.dart';

class SessionDatasourceImple implements SessionDataSource{
  final AuthClient _authClient;
  SessionDatasourceImple({required this._authClient});

  @override
  Future<void> signOut() async {
    try {
      if(FirebaseAuth.instance.currentUser != null) {
       await _authClient.signOut();
      }else{
        throw AuthException('user_not_found');
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign out: ${e.toString()}');
    }
  }
}