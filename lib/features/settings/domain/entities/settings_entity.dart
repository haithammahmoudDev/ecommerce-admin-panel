import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String? id;
  final double taxRate;
  final double shippingCost;
  final double? freeShippingThreshold;
  final String appName;
  final String appLogo;

  const SettingsEntity({
    this.id,
    this.taxRate = 0.0,
    this.shippingCost = 0.0,
    this.freeShippingThreshold,
    this.appName = '',
    this.appLogo = '',
  });

  SettingsEntity copyWith({
    String? id,
    double? taxRate,
    double? shippingCost,
    double? freeShippingThreshold,
    String? appName,
    String? appLogo,
  }) {
    return SettingsEntity(
      id: id ?? this.id,
      taxRate: taxRate ?? this.taxRate,
      shippingCost: shippingCost ?? this.shippingCost,
      freeShippingThreshold: freeShippingThreshold ?? this.freeShippingThreshold,
      appName: appName ?? this.appName,
      appLogo: appLogo ?? this.appLogo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    taxRate,
    shippingCost,
    freeShippingThreshold,
    appName,
    appLogo,
  ];
}