import 'package:hive_ce_flutter/adapters.dart';
import '../../features/order/domain/entities/user_entity.dart';
import '../../features/order/domain/entities/user_entity_adapter.dart';

class UserRepository {
  UserRepository._();
  static final UserRepository instance = UserRepository._();
  factory UserRepository(){
    return instance;
  }

  static const String _boxName = 'admin_box';
  static const String _adminKey = 'current_user';

  late final Box<UserEntity> _box;

  // ⚠️ تم التحديث: دالة الـ Init الذكية والآمنة مع الـ Hot Restart
  Future<void> init() async {
    await Hive.initFlutter();

    // 1. تسجيل الـ Adapter بأمان قبل أي عملية فتح
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserEntityAdapter());
    }

    // 2. حل مشكلة الـ Hot Restart: إذا كان الـ Box مفتوحاً مسبقاً، نقوم بإغلاقه أولاً لتفادي تعارض الأنواع
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box(_boxName).close();
    }

    // 3. الآن نفتح الـ Box بأمان كامل بالنوع المخصص UserModel
    _box = await Hive.openBox<UserEntity>(_boxName);
  }

  UserEntity? getUser() => _box.get(_adminKey);

  Future<void> saveUser(UserEntity user) async {
    await _box.put(_adminKey, user);
  }

  Future<void> updateUser({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? image,
  }) async {
    final currentUser = getUser();
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      fullName: fullName ?? currentUser.fullName,
      email: email ?? currentUser.email,
      profilePicture: image ?? currentUser.profilePicture,
      phoneNumber: phoneNumber ?? currentUser.phoneNumber, // ✅ تم تصحيح خطأ كتابي بسيط هنا بدلاً من profilePicture
    );

    await saveUser(updatedUser);
  }

  Future<void> clearUser() async {
    await _box.delete(_adminKey);
  }
}
