// core/errors/failure.dart

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  // كود الخطأ الخام (مثلاً 'email-already-in-use')
  // بيستخدمه الـ Cubit/Bloc عشان يقرر يوجه اليوزر فين، من غير ما يحلل نص الرسالة
  final String? code;

  const AuthFailure(super.message, {this.code});
}

class NetworkFailure extends Failure {               // ← add this
  const NetworkFailure(super.message);
}