import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<User?> _subscription;

  AuthRefreshNotifier() {
    _subscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
          notifyListeners();
        });
  }

  // 💡 إضافة الـ Getters لقراءة حالة المستخدم لحظياً من الذاكرة ومنع ثقل التنقل
  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  bool get isEmailVerified => FirebaseAuth.instance.currentUser?.emailVerified ?? false;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
