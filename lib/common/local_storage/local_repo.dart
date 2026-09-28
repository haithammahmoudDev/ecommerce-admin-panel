import 'package:hive_ce_flutter/adapters.dart';

class LocalRepository<T> {
  final String boxName;
  final String key;

  /// Required when T is a List<CustomModel>.
  /// Example: (raw) => (raw as List).cast<ProductModel>()
  final T Function(dynamic raw)? fromStorage;

  LocalRepository({
    required this.boxName,
    required this.key,
    this.fromStorage,
  });

  late final Box<dynamic> _box;

  /// Generic so Dart infers A from the adapter itself,
  /// preventing registerAdapter<dynamic>(...) silently.
  Future<void> init<A>({
    required TypeAdapter<A> adapter,
    required int typeId,
  }) async {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter<A>(adapter);
    }

    try {
      _box = await Hive.openBox<dynamic>(boxName);
    } catch (e) {
      try {
        // إذا فشل الفتح، نحاول حذف الصندوق التالف بأمان
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).close();
        }
        await Hive.deleteBoxFromDisk(boxName);
      } catch (_) {
      }
      _box = await Hive.openBox<dynamic>(boxName);
    }
  }

  /// لفتح Box بدون تسجيل أي TypeAdapter — يُستخدم للبيانات الأولية
  /// (Map/String/bool/num...) زي خريطة معرفات المفضلة اللي مش محتاجة Adapter.
  Future<void> initRaw() async {
    try {
      _box = await Hive.openBox<dynamic>(boxName);
    } catch (e) {
      try {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).close();
        }
        await Hive.deleteBoxFromDisk(boxName);
      } catch (_) {
      }
      _box = await Hive.openBox<dynamic>(boxName);
    }
  }

  /// لجلب البيانات: إذا مررت الـ ID في customKey سيجلب بيانات هذا الـ ID، وإلا سيجلب الـ key الافتراضي
  T? getData({String? customKey}) {
    final activeKey = customKey ?? key;
    final data = _box.get(activeKey);
    if (data == null) return null;
    return fromStorage != null ? fromStorage!(data) : data as T;
  }

  /// لحفظ البيانات: يحفظ البيانات تحت الـ ID الممرر في customKey بشكل ديناميكي
  Future<void> saveData(T data, {String? customKey}) async {
    final activeKey = customKey ?? key;
    await _box.put(activeKey, data);
  }

  /// لتحديث البيانات ديناميكيًا بناءً على المفتاح
  Future<void> updateData(T Function(T currentData) onUpdate, {String? customKey}) async {
    final activeKey = customKey ?? key;
    final currentData = getData(customKey: activeKey);
    if (currentData == null) return;
    await saveData(onUpdate(currentData), customKey: activeKey);
  }

  /// لحذف بيانات مفتاح معين (أو ID معين)
  Future<void> clearData({String? customKey}) async {
    final activeKey = customKey ?? key;
    await _box.delete(activeKey);
  }

  /// لتفريغ الـ Box بالكامل
  Future<void> clearBox() async {
    await _box.clear();
  }
}