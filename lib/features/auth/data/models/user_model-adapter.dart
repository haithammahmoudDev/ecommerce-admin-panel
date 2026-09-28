import 'package:hive_ce_flutter/adapters.dart';
import '../../../../utils/constants/enums.dart';
import '../../../order/data/models/address_model.dart';
import '../../../order/data/models/order_model.dart';
import 'user_model.dart';

class UserAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return UserModel(
      id: fields[0] as String? ?? '',
      fullName: fields[1] as String? ?? '',
      email: fields[2] as String? ?? '',
      phoneNumber: fields[3] as String? ?? '',
      profilePicture: fields[4] as String? ?? '',
      role: fields[5] != null ? AppRole.values[fields[5] as int] : AppRole.admin,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
      orders: (fields[8] as List?)?.cast<OrderModel>(),
      addresses: (fields[9] as List?)?.cast<AddressModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(10) // إجمالي عدد الحقول (من 0 إلى 9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.profilePicture)
      ..writeByte(5)
      ..write(obj.role.index)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.orders)
      ..writeByte(9)
      ..write(obj.addresses);
  }
}