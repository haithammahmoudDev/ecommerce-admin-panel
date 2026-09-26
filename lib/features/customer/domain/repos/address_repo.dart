import 'package:dartz/dartz.dart';

import '../../../../common/errors/failure.dart';
import '../../../order/domain/entities/address_entity.dart';

abstract class AddressRepo {
  Future<Either<Failure, List<AddressEntity>>> fetchUserAddresses(String userId);
  Future<Either<Failure, void>> updateSelectedField({
    required String addressId,
    required bool selected,
  });
}