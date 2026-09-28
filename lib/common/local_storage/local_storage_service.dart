import 'package:hive_ce_flutter/adapters.dart';


class TLocalStorage {
  late final Box _storage;

  static TLocalStorage? _instance;

  TLocalStorage._internal();

  factory TLocalStorage.instance() {
    _instance ??= TLocalStorage._internal();
    return _instance!;
  }

  static Future<void> init() async {
    await Hive.initFlutter();

    // *** ده السطر اللي كان ناقص وبيسبب الخطأ ***
    // if (!Hive.isAdapterRegistered(32)) {
    //   Hive.registerAdapter(CategoryEntityAdapter());
    // }
    // لو فيه كلاسات تانية بتتخزن في نفس الـ box، سجّل الـ adapters
    // بتاعتها هنا كمان بنفس الطريقة (قبل openBox).

    _instance = TLocalStorage._internal();

    try {
      _instance!._storage = await Hive.openBox('user_box');
    } catch (e) {
      // لو الـ box فاسد (corrupted) أو فيه بيانات بنوع مش متسجل،
      // امسحه وأعد إنشاءه بدل ما التطبيق يكراش بالكامل.
      // deleteBoxFromDisk ممكن ترمي خطأ لو ملف الـ .lock مش موجود
      // أصلاً (bug معروف في hive_ce) - بنتجاهله ونكمل عادي.
      try {
        await Hive.deleteBoxFromDisk('user_box');
      } catch (_) {
        // تجاهل - المهم إن الـ box يتفتح بنجاح بعد كده
      }
      _instance!._storage = await Hive.openBox('user_box');
    }
  }

  Future<void> writeData<T>(String key, T value) async {
    if (!_storage.isOpen) return; // حماية من مشكلة Hot Restart
    await _storage.put(key, value);
  }

  T? readData<T>(String key) {
    if (!_storage.isOpen) return null; // حماية من مشكلة Hot Restart
    return _storage.get(key) as T?;
  }

  /// استخدم الدالة دي بدل readData لما تقرأ List من objects مخصصة
  /// (زي List<CategoryEntity>). Hive بيرجّع الـ Lists المخزنة كـ
  /// List<dynamic> حتى لو العناصر جواها فعليًا من نوع CategoryEntity،
  /// فمحاولة (value as List<CategoryEntity>) بترمي TypeError. هنا بنعمل
  /// .cast<E>() اللي بيفحص نوع كل عنصر وقت التشغيل بدل الـ cast المباشر
  /// على الـ List نفسها.
  /// الاستخدام: readList<CategoryEntity>('categories')
  List<E>? readList<E>(String key) {
    if (!_storage.isOpen) return null; // حماية من مشكلة Hot Restart
    final value = _storage.get(key);
    if (value == null) return null;
    return (value as List).cast<E>();
  }

  Future<void> removeData(String key) async {
    if (!_storage.isOpen) return;
    await _storage.delete(key);
  }

  Future<void> clearAll() async {
    if (!_storage.isOpen) return;
    await _storage.clear();
  }
}

