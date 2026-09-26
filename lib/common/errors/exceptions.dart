// core/errors/exceptions.dart

class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException(super.message);
}

class AuthException extends AppException {
  // كود الخطأ الخام من Firebase (مثلاً 'email-already-in-use')
  // اختياري عشان مايكسرش أي مكان تاني بيستخدم AuthException(message) من غير code
  final String? code;

  AuthException(super.message, {this.code});
}

class NetworkException extends AppException {        // ← add this
  NetworkException(super.message);
}