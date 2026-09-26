import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

import '../popups/loaders.dart';

/// Manages the network connectivity status.
class NetworkManager {
  NetworkManager._internal() {
    // التعديل: تم جعل الـ listen يستقبل النتيجة فقط ويمررها للدالة المحدثة
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  static final NetworkManager _instance = NetworkManager._internal();

  factory NetworkManager() => _instance;

  static NetworkManager get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  late final StreamSubscription<List<ConnectivityResult>>
  _connectivitySubscription;

  List<ConnectivityResult> _connectionStatus = [];

  // التعديل: تم إزالة الـ BuildContext من دالة التحديث التلقائي لتجنب أخطاء الـ Compile
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;

    if (result.contains(ConnectivityResult.none)) {
      // إذا أردت إظهار الـ Toast هنا بدون context، يمكنك استخدام Get.snackbar القديم
      // أو تركه فارغاً والاعتماد على الـ UI والـ Cubit لإظهار الأخطاء
    }
  }

  /// Check the internet connection status.
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    } on PlatformException {
      return false;
    }
  }

  /// Dispose the connectivity stream.
  void dispose() {
    _connectivitySubscription.cancel();
  }
}
