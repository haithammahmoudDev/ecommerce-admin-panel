import 'package:dartz/dartz.dart';
import '../../../../common/errors/failure.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepo {
  Future<Either<Failure, SettingsEntity>> getSettings();
  Future<Either<Failure, void>> registerSettings(SettingsEntity setting);
  Future<Either<Failure, void>> updateSettingDetails(SettingsEntity updatedSetting);
  Future<Either<Failure, void>> updateSingleField(Map<String, dynamic> json);
}