import 'package:hive_ce_flutter/adapters.dart';

class TLocalStorage {
  late final Box _storage;

  // Singleton instance
  static TLocalStorage? _instance;

  TLocalStorage._internal();

  /// Create a named constructor to obtain an instance with a specific bucket name
  factory TLocalStorage.instance() {
    _instance ??= TLocalStorage._internal();
    return _instance!;
  }

  /// Asynchronous initialization method
  /// bucketName = اسم الـ box الخاص باليوزر (زي ما كان في GetStorage.init(bucketName))
  static Future<void> init(String bucketName) async {
    await Hive.initFlutter();

    _instance = TLocalStorage._internal();
    _instance!._storage = await Hive.openBox(bucketName);
  }

  /// Generic method to save data
  Future<void> writeData<T>(String key, T value) async {
    await _storage.put(key, value);
  }

  /// Generic method to read data
  T? readData<T>(String key) {
    return _storage.get(key) as T?;
  }

  /// Generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.delete(key);
  }

  /// Clear all data in storage
  Future<void> clearAll() async {
    await _storage.clear();
  }
}