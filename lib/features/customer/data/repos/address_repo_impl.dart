import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../common/errors/failure.dart';
import '../../../order/data/models/address_model.dart';
import '../../../order/domain/entities/address_entity.dart';
import '../../domain/repos/address_repo.dart';

class AddressRepositoryImpl implements AddressRepo {
  final FirebaseFirestore _db;

  AddressRepositoryImpl({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  /// جلب عناوين المستخدم
  @override
  Future<Either<Failure, List<AddressEntity>>> fetchUserAddresses(
      String userId) async {
    try {
      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .get();

      final addresses = result.docs
          .map((doc) => AddressModel.fromFirebaseData(
        doc.data(),
        docId: doc.id,
      ).toEntity())
          .toList();

      return Right(addresses);
    } catch (e) {
      return Left(
        ServerFailure('حدث خطأ أثناء جلب عناوين المستخدم: ${e.toString()}'),
      );
    }
  }

  /// تحديث تحديد العنوان
  @override
  Future<Either<Failure, void>> updateSelectedField({
     required String addressId,
    required bool selected,
  }) async {
    try {
      await _db
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Addresses')
          .doc(addressId)
          .update({'SelectedAddress': selected});

      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure('حدث خطأ أثناء تحديث العنوان المحدد: ${e.toString()}'),
      );
    }
  }
}