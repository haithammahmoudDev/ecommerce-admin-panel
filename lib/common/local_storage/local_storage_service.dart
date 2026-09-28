import 'package:hive_ce_flutter/adapters.dart';
import '../../features/auth/data/models/user_model-adapter.dart';
import '../../features/auth/data/models/user_model.dart';
import 'local_repo.dart';


class LocalStorageService {
  static late final LocalRepository<UserModel> userRepo;


  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter<UserModel>(UserAdapter());
    }

    userRepo = LocalRepository<UserModel>(
      boxName: 'user_box',
      key: 'current_user',
    );
    await userRepo.init<UserModel>(
      adapter: UserAdapter(),
      typeId: 0,
    );
  }
}