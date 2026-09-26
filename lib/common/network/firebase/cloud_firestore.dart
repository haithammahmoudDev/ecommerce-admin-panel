// core/network/firebase/cloud_firestore.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'database_services.dart';

class CloudFirestore implements DatabaseServices {
  final FirebaseFirestore firestore;
  CloudFirestore(this.firestore);

  @override
  Future<void> addData({required String path, required Map<String, dynamic> data}) async =>
      await firestore.collection(path).add(data);

  // FIX: كانت هذه الدالة غير منفذة (throw UnimplementedError()) رغم أنها
  // مستخدمة في كل عمليات الإنشاء بالمشروع (createCategory, createBrand,
  // createBrandCategory, createProduct, createProductCategory). أي زر
  // "حفظ" لإنشاء سجل جديد كان يتسبب في كراش فوري بسبب هذا الاستثناء.
  @override
  Future<String> addDataAndGetId({required String path, required Map<String, dynamic> data}) async {
    final docRef = await firestore.collection(path).add(data);
    return docRef.id;
  }

  @override
  Future<void> setData({required String path, required String docId, required Map<String, dynamic> data}) async =>
      await firestore.collection(path).doc(docId).set(data, SetOptions(merge: true));

  @override
  Future<void> updateData({required String path, required String docId, required Map<String, dynamic> data}) async =>
      await firestore.collection(path).doc(docId).update(data);

  @override
  Future<void> deleteData({required String path, required String docId}) async =>
      await firestore.collection(path).doc(docId).delete();

  @override
  Future<dynamic> getData({required String path, String? docId, Map<String, dynamic>? query}) async {
    if (docId != null) {
      final data = await firestore.collection(path).doc(docId).get();
      return data.data();
    }

    Query<Map<String, dynamic>> q = firestore.collection(path);

    if (query != null) {
      // ✅ جديدة: فلترة where
      if (query['where'] != null) {
        final whereClause = query['where'] as Map<String, dynamic>;
        q = q.where(whereClause['field'], isEqualTo: whereClause['value']);
      }
      if (query['orderBy'] != null) {
        q = q.orderBy(query['orderBy'], descending: query['descending'] ?? true);
      }
      if (query['limit'] != null) q = q.limit(query['limit']);
    }

    final result = await q.get();

    // ✅ نحافظ على الـ id بتاع كل document جوه الـ Map نفسها
    return result.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // FIX: كانت غير منفذة (throw UnimplementedError()). أي كود بيتحقق من
  // وجود مستند معين قبل عملية ما (زي منع تكرار إنشاء سجل) كان بيكراش.
  @override
  Future<bool> checkIfDataExist({required String path, required String docId}) async {
    final doc = await firestore.collection(path).doc(docId).get();
    return doc.exists;
  }

  // FIX: كانت غير منفذة (throw UnimplementedError()). بترجع أول مستند
  // مطابق لقيمة حقل معين، مع إرفاق الـ id الحقيقي بنفس طريقة getData().
  @override
  Future<Map<String, dynamic>?> getDataWhere({
    required String path,
    required String field,
    required dynamic value,
  }) async {
    final querySnapshot =
    await firestore.collection(path).where(field, isEqualTo: value).limit(1).get();

    if (querySnapshot.docs.isEmpty) return null;

    final data = querySnapshot.docs.first.data();
    data['id'] = querySnapshot.docs.first.id;
    return data;
  }
}