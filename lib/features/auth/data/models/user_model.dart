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
  final String email;
  final String phoneNumber;
  final String profilePicture;
  final AppRole role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    this.fullName = '',
    required this.email,
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.admin,
    this.createdAt,
    this.updatedAt,
   });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    AppRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderModel>? orders,
    List<AddressModel>? addresses,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
     );
  }

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
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role.name,
      'CreatedAt': createdAt?.toIso8601String(),
      'UpdatedAt': updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

   static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date);
    if (date is int) return DateTime.fromMillisecondsSinceEpoch(date);
    return null;
  }

   factory UserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return UserModel.empty();

    return UserModel(
      id: json['Id'] ?? json['id'] ?? '',
      fullName: json['FullName'] ?? json['fullName'] ?? '',
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

   factory UserModel.fromFirebaseData(
      Map<String, dynamic>? data, {
        String? docId,
      }) {
    if (data == null || data.isEmpty) return UserModel.empty();

    return UserModel(
      id: docId ?? data['Id'] ?? data['id'] ?? '',
      fullName: data['FullName'] ?? '',
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
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
      role: entity.role,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
     );
  }

  /// Convert Data Model to Domain Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
     );
  }
}