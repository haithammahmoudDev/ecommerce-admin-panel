import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../../../common/errors/failure.dart';
import '../../../../common/network/firebase/database_services.dart';
import '../../domain/entities/order_entity.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repos/user_repo.dart';
import '../models/order_model.dart';
import '../../../auth/data/models/user_model.dart';

class UserRepoImpl implements UserRepo {
  final FirebaseFirestore _db;
  final DatabaseServices _databaseServices;

  UserRepoImpl({FirebaseFirestore? db, required this._databaseServices})
      : _db = db ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final querySnapshot =
      await _db.collection("users").orderBy("FullName").get();

      final users = querySnapshot.docs
          .map((doc) =>
          UserModel.fromFirebaseData(doc.data(), docId: doc.id).toEntity())
          .toList();

      return Right(users);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error occurred.'));
    } on PlatformException catch (e) {
      return Left(ServerFailure(e.message ?? 'Platform error occurred.'));
    } on FormatException catch (_) {
      return Left(const ServerFailure('Data format error occurred.'));
    } catch (e) {
      return Left(ServerFailure('Something went wrong: ${e.toString()}'));
    }
  }

   @override
  Future<Either<Failure, UserEntity>> getUserDetail(String id) async {
    try {
      final documentSnapshot = await _db.collection("users").doc(id).get();

      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        final userEntity = UserModel.fromFirebaseData(
          documentSnapshot.data(),
          docId: documentSnapshot.id,
        ).toEntity();

        return Right(userEntity);
      } else {
        return Right(UserEntity.empty);
      }
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error occurred.'));
    } on PlatformException catch (e) {
      return Left(ServerFailure(e.message ?? 'Platform error occurred.'));
    } on FormatException catch (_) {
      return Left(const ServerFailure('Data format error occurred.'));
    } catch (e) {
      return Left(ServerFailure('Something went wrong: ${e.toString()}'));
    }
  }

   @override
  Future<Either<Failure, void>> createUser({required UserEntity user}) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _databaseServices.setData(
        path: 'users',
        docId: userModel.id,
        data: userModel.toJson(),
      );
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error occurred.'));
    } on PlatformException catch (e) {
      return Left(ServerFailure(e.message ?? 'Platform error occurred.'));
    } on FormatException catch (_) {
      return Left(const ServerFailure('Data format error occurred.'));
    } catch (e) {
      return Left(ServerFailure('Something went wrong: ${e.toString()}'));
    }
  }

   @override
  Future<Either<Failure, void>> updateSingleField(
      {required Map<String, dynamic> json}) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      await _databaseServices.updateData(
        path: 'users',
        docId: currentUserId,
        data: json,
      );
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error occurred.'));
    } on PlatformException catch (e) {
      return Left(ServerFailure(e.message ?? 'Platform error occurred.'));
    } on FormatException catch (_) {
      return Left(const ServerFailure('Data format error occurred.'));
    } catch (e) {
      return Left(ServerFailure('Something went wrong: ${e.toString()}'));
    }
  }

   @override
  Future<Either<Failure, List<OrderEntity>>> fetchUserOrders(
      String userId) async {
    try {
      final querySnapshot = await _db
          .collection("Orders")
          .where('userId', isEqualTo: userId)
          .get();

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromFirebaseData(
        doc.data(),
        doc.id,
      ).toEntity())
          .toList();

      return Right(orders);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error occurred.'));
    } on PlatformException catch (e) {
      return Left(ServerFailure(e.message ?? 'Platform error occurred.'));
    } on FormatException catch (_) {
      return Left(const ServerFailure('Data format error occurred.'));
    } catch (e) {
      return Left(ServerFailure('Something went wrong: ${e.toString()}'));
    }
  }

   @override
  Future<Either<Failure, void>> deleteUser({required String id}) async {
    try {
      await _databaseServices.deleteData(
        path: 'users',
        docId: id,
      );
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error occurred.'));
    } on PlatformException catch (e) {
      return Left(ServerFailure(e.message ?? 'Platform error occurred.'));
    } on FormatException catch (_) {
      return Left(const ServerFailure('Data format error occurred.'));
    } catch (e) {
      return Left(ServerFailure('Something went wrong: ${e.toString()}'));
    }
  }

   @override
  Future<Either<Failure, UserEntity>> fetchAdminDetails() async {
    try {
      final currentAdminId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (currentAdminId.isEmpty) {
        return Left(const ServerFailure('No authenticated admin user found.'));
      }

      final documentSnapshot =
      await _db.collection("users").doc(currentAdminId).get();

      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        final adminEntity = UserModel.fromFirebaseData(
          documentSnapshot.data(),
          docId: documentSnapshot.id,
        ).toEntity();

        return Right(adminEntity);
      } else {
        return Right(UserEntity.empty);
      }
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error occurred.'));
    } on PlatformException catch (e) {
      return Left(ServerFailure(e.message ?? 'Platform error occurred.'));
    } on FormatException catch (_) {
      return Left(const ServerFailure('Data format error occurred.'));
    } catch (e) {
      return Left(ServerFailure('Something went wrong: ${e.toString()}'));
    }
  }
}