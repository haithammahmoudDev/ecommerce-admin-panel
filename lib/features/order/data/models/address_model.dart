import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../domain/entities/address_entity.dart';

class AddressModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final DateTime? dateTime;
  final bool selectedAddress;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.dateTime,
    this.selectedAddress = true,
  });

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static AddressModel empty() => AddressModel(
    id: '',
    name: '',
    phoneNumber: '',
    street: '',
    city: '',
    state: '',
    postalCode: '',
    country: '',
  );

  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date);
    if (date is int) return DateTime.fromMillisecondsSinceEpoch(date);
    return null;
  }

   factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      dateTime: _parseDate(json['dateTime']),
      selectedAddress: json['selectedAddress'] ?? true,
    );
  }

   factory AddressModel.fromFirebaseData(
      Map<String, dynamic>? json, {
        String? docId,
      }) {
    final data = json ?? {};
    return AddressModel(
      id: docId ?? data['id'] ?? '',
      name: data['Name'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      street: data['Street'] ?? '',
      city: data['City'] ?? '',
      state: data['State'] ?? '',
      postalCode: data['PostalCode'] ?? '',
      country: data['Country'] ?? '',
      selectedAddress: data['SelectedAddress'] ?? false,
      dateTime: _parseDate(data['DateTime']),
    );
  }

   factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      street: entity.street,
      city: entity.city,
      state: entity.state,
      postalCode: entity.postalCode,
      country: entity.country,
      dateTime: entity.dateTime,
      selectedAddress: entity.selectedAddress,
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'dateTime': dateTime?.toIso8601String(),
      'selectedAddress': selectedAddress,
    };
  }

   AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      dateTime: dateTime,
      selectedAddress: selectedAddress,
    );
  }
}