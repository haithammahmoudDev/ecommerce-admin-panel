import '../../domain/entities/settings_entity.dart';

class SettingsModel {
  final String? id;
  double taxRate;
  double shippingCost;
  double? freeShippingThreshold;
  String appName;
  String appLogo;

  SettingsModel({
    this.id,
    this.taxRate = 0.0,
    this.shippingCost = 0.0,
    this.freeShippingThreshold,
    this.appName = '',
    this.appLogo = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'taxRate': taxRate,
      'shippingCost': shippingCost,
      'freeShippingThreshold': freeShippingThreshold,
      'appName': appName,
      'appLogo': appLogo,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return SettingsModel(
      id: docId,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0.0,
      freeShippingThreshold: (json['freeShippingThreshold'] as num?)?.toDouble(),
      appName: json['appName'] as String? ?? '',
      appLogo: json['appLogo'] as String? ?? '',
    );
  }

  factory SettingsModel.fromFirebaseData(Map<String, dynamic> data, {String? docId}) {
    return SettingsModel(
      id: docId,
      taxRate: (data['taxRate'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (data['shippingCost'] as num?)?.toDouble() ?? 0.0,
      freeShippingThreshold: (data['freeShippingThreshold'] as num?)?.toDouble() ?? 0.0,
      appName: data.containsKey('appName') ? data['appName'] ?? '' : '',
      appLogo: data.containsKey('appLogo') ? data['appLogo'] ?? '' : '',
    );
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      id: id,
      taxRate: taxRate,
      shippingCost: shippingCost,
      freeShippingThreshold: freeShippingThreshold,
      appName: appName,
      appLogo: appLogo,
    );
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      id: entity.id,
      taxRate: entity.taxRate,
      shippingCost: entity.shippingCost,
      freeShippingThreshold: entity.freeShippingThreshold,
      appName: entity.appName,
      appLogo: entity.appLogo,
    );
  }

}
