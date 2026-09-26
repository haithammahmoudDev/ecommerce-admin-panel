import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/common/network/firebase/database_services.dart';

import 'package:ecommerce_admin_pannal/features/banner/data/models/banner_model.dart';

import 'package:ecommerce_admin_pannal/features/banner/domain/entities/banner_entity.dart';

import '../../domain/repos/banner_repo.dart';

class BannerRepoImpl implements BannerRepo{
  final DatabaseServices _databaseServices;
  BannerRepoImpl({required this._databaseServices});

  @override
  Future<Either<Failure, String>> createBanner(BannerModel banner) async{
    try {
      final String bannerId= await _databaseServices.addDataAndGetId(path: 'Banners',
          data: banner.toJson());
      return right(bannerId);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBanner(String bannerId) async{
    try {
      await _databaseServices.deleteData(path: 'Banners', docId: bannerId);
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BannerEntity>>> getAllBanner() async{
    try{
      final querySnapshot = await FirebaseFirestore.instance.collection('Banners').get();
      final List<BannerEntity> bannerList =
      querySnapshot.docs
          .map((doc) =>
          BannerModel.fromFirebaseData(doc.data(),doc.id).toEntity())
          .toList();
     return right(bannerList);
    }catch(e){
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editBanner(BannerModel banner) async{
    try {
      await _databaseServices.setData(path: 'Banners', docId: banner.id, data: banner.toJson());
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}