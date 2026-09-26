import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_pannal/features/settings/domain/repos/settings_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:dartz/dartz.dart'; // أو fpdart حسب المكتبة المستعملة عندك
import '../../../../common/errors/failure.dart';
import '../../../../common/errors/format_exceptions.dart';
import '../../../../common/errors/platform_exceptions.dart';
import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../domain/entities/settings_entity.dart';
import '../model/settings_model.dart';


/// Repository class for setting-related operations.
class SettingsRepoImpl implements SettingsRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save setting data to Firestore.
  Future<Either<Failure, void>> registerSettings(SettingsEntity setting) async {
    try {
      final model = SettingsModel.fromEntity(setting);
      await _db.collection("Settings").doc('GLOBAL_SETTINGS').set(
          model.toJson());
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  /// Function to fetch setting details based on setting ID.
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final docSnapshot = await _db.collection("Settings").doc(
          'GLOBAL_SETTINGS').get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return Left(ServerFailure('Settings data not found.'));
      }

      // Convert Firebase Data to Model using fromFirebaseData then convert to Entity
      final settingsModel = SettingsModel.fromFirebaseData(
        docSnapshot.data()!,
        docId: docSnapshot.id,
      );

      return Right(settingsModel.toEntity());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  /// Function to update setting data in Firestore.
  Future<Either<Failure, void>> updateSettingDetails(SettingsEntity updatedSetting) async {
    try {
      // Convert Entity to Model to get toJson()
      final model = SettingsModel.fromEntity(updatedSetting);

      // ✅ Use set with SetOptions(merge: true) instead of update
      await _db
          .collection("Settings")
          .doc('GLOBAL_SETTINGS')
          .set(model.toJson(), SetOptions(merge: true));

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Update any field in specific Settings Collection
  @override
  Future<Either<Failure, void>> updateSingleField(Map<String, dynamic> json) async {
    try {
      // ✅ استخدام set مع merge بدلاً من update
      await _db
          .collection("Settings")
          .doc('GLOBAL_SETTINGS')
          .set(json, SetOptions(merge: true));

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}