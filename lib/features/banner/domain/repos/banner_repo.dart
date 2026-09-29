import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/features/banner/domain/entities/banner_entity.dart';
import '../../../../common/errors/failure.dart';
import '../../data/models/banner_model.dart';

abstract class BannerRepo {
  Future<Either<Failure, List<BannerEntity>>> getAllBanner();
  Future<Either<Failure, String>> createBanner(BannerModel banner);
  Future<Either<Failure, void>> deleteBanner(String bannerId);
  Future<Either<Failure, void>> editBanner(BannerModel banner);}