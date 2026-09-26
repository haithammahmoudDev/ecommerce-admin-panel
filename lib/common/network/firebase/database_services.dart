// core/network/firebase/database_services.dart

abstract class DatabaseServices {
  Future<void> addData({required String path, required Map<String, dynamic> data});

  Future<String> addDataAndGetId({required String path, required Map<String, dynamic> data});

  Future<void> setData({required String path, required String docId, required Map<String, dynamic> data});

  Future<void> updateData({required String path, required String docId, required Map<String, dynamic> data});

  Future<void> deleteData({required String path, required String docId});

  Future<dynamic> getData({required String path, String? docId, Map<String, dynamic>? query});

  Future<bool> checkIfDataExist({required String path, required String docId});

  Future<Map<String, dynamic>?> getDataWhere({
    required String path,
    required String field,
    required dynamic value,
  });
}