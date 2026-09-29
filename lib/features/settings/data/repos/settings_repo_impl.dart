import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_pannal/features/settings/domain/repos/settings_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../common/errors/failure.dart';
import '../../domain/entities/settings_entity.dart';
import '../model/settings_model.dart';


 class SettingsRepoImpl implements SettingsRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

   @override
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

   @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final docSnapshot = await _db.collection("Settings").doc(
          'GLOBAL_SETTINGS').get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return Left(ServerFailure('Settings data not found.'));
      }

       final settingsModel = SettingsModel.fromFirebaseData(
        docSnapshot.data()!,
        docId: docSnapshot.id,
      );

      return Right(settingsModel.toEntity());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

   @override
  Future<Either<Failure, void>> updateSettingDetails(SettingsEntity updatedSetting) async {
    try {
       final model = SettingsModel.fromEntity(updatedSetting);

       await _db
          .collection("Settings")
          .doc('GLOBAL_SETTINGS')
          .set(model.toJson(), SetOptions(merge: true));

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

   @override
  Future<Either<Failure, void>> updateSingleField(Map<String, dynamic> json) async {
    try {
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