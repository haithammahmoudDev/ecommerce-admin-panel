import '../../data/models/address_model.dart';

class AddressEntity {
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

  AddressEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.dateTime,
    required this.selectedAddress,
  });

  /// Factory method to return an empty AddressEntity
  static AddressEntity empty() => AddressEntity(
    id: '',
    name: '',
    phoneNumber: '',
    street: '',
    city: '',
    state: '',
    postalCode: '',
    country: '',
    dateTime: null,
    selectedAddress: false,
  );

  // Convert AddressEntity back into a Data AddressModel
  AddressModel toModel() {
    return AddressModel(
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

  @override
  String toString() {
    return '$street, $city, $state $postalCode, $country';
  }
}