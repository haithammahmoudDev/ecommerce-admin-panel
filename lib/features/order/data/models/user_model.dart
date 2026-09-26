import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../domain/entities/user_entity.dart';
import 'address_model.dart';
import 'order_model.dart';

class UserModel {
  final String id;
  final String fullName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String profilePicture;
  final AppRole role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderModel>? orders;
  final List<AddressModel>? addresses;

  UserModel({
    required this.id,
    this.fullName = '',
    this.userName = '',
    required this.email,
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
    this.orders,
    this.addresses,
  });

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  String get formattedDate =>
      createdAt != null ? TFormatter.formatDate(createdAt!) : '';

  String get formattedUpdatedAtDate =>
      updatedAt != null ? TFormatter.formatDate(updatedAt!) : '';

  static UserModel empty() => UserModel(
    id: '',
    email: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() {
    return {
      'FullName': fullName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role.name,
      'CreatedAt': createdAt?.toIso8601String(),
      'UpdatedAt': updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  /// Safe date parser for Firebase & JSON data
  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date);
    if (date is int) return DateTime.fromMillisecondsSinceEpoch(date);
    return null;
  }

  /// Factory method to create UserModel from standard JSON Map
  factory UserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return UserModel.empty();

    return UserModel(
      id: json['Id'] ?? json['id'] ?? '',
      fullName: json['FullName'] ?? json['fullName'] ?? '',
      userName: json['UserName'] ?? json['userName'] ?? '',
      email: json['Email'] ?? json['email'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? json['phoneNumber'] ?? '',
      profilePicture: json['ProfilePicture'] ?? json['profilePicture'] ?? '',
      role: (json['Role'] == AppRole.admin.name || json['role'] == AppRole.admin.name)
          ? AppRole.admin
          : AppRole.user,
      createdAt: _parseDate(json['CreatedAt'] ?? json['createdAt']),
      updatedAt: _parseDate(json['UpdatedAt'] ?? json['updatedAt']),
    );
  }

  /// Create UserModel directly from raw Firebase Map data
  factory UserModel.fromFirebaseData(
      Map<String, dynamic>? data, {
        String? docId,
      }) {
    if (data == null || data.isEmpty) return UserModel.empty();

    return UserModel(
      id: docId ?? data['Id'] ?? data['id'] ?? '',
      fullName: data['FullName'] ?? '',
      userName: data['UserName'] ?? '',
      email: data['Email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
      role: data['Role'] == AppRole.admin.name ? AppRole.admin : AppRole.user,
      createdAt: _parseDate(data['CreatedAt']),
      updatedAt: _parseDate(data['UpdatedAt']),
    );
  }

  /// Create UserModel from FirebaseAuth User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      fullName: user.displayName ?? '',
      userName: user.email != null ? user.email!.split('@').first : '',
      email: user.email ?? '',
      phoneNumber: user.phoneNumber ?? '',
      profilePicture: user.photoURL ??
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      role: AppRole.user,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Factory method to create a UserModel from a DocumentSnapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    return UserModel.fromFirebaseData(
      document.data(),
      docId: document.id,
    );
  }

  /// Convert Domain Entity to Data Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      userName: entity.userName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
      role: entity.role,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      orders: entity.orders?.map((o) => OrderModel.fromEntity(o)).toList(),
      addresses: entity.addresses?.map((a) => AddressModel.fromEntity(a)).toList(),
    );
  }

  /// Convert Data Model to Domain Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      userName: userName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
      orders: orders?.map((o) => o.toEntity()).toList(),
      addresses: addresses?.map((a) => a.toEntity()).toList(),
    );
  }
}