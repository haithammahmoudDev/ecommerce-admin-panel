import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_pannal/features/auth/data/data_source/profile_datasource.dart';
import 'package:ecommerce_admin_pannal/features/auth/data/repos/profile_repo_imple.dart';
import 'package:ecommerce_admin_pannal/features/banner/domain/repos/banner_repo.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/controller/banner_cubit.dart';
import 'package:ecommerce_admin_pannal/features/brand/data/repos/brand_repo_imple.dart';
import 'package:ecommerce_admin_pannal/features/brand/domain/repos/brand_repo.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/brand_cubit.dart';
import 'package:ecommerce_admin_pannal/features/categories/data/repos/category_repo_impl.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/repos/category_repo.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
import 'package:ecommerce_admin_pannal/features/customer/data/repos/address_repo_impl.dart';
import 'package:ecommerce_admin_pannal/features/customer/domain/repos/address_repo.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/controller/customer_controller.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/controller/customer_detail_controller/customer_detail_cubit.dart';
import 'package:ecommerce_admin_pannal/features/dashboard/presentation/controller/dashboard_cubit/dashboard_cubit.dart';
import 'package:ecommerce_admin_pannal/features/media/data/repo/media_repo_imple.dart';
import 'package:ecommerce_admin_pannal/features/media/domain/repo/media_repo.dart';
import 'package:ecommerce_admin_pannal/features/media/presentation/controller/media_cubit/media_cubit.dart';
import 'package:ecommerce_admin_pannal/features/order/data/repos/order_repo_impl.dart';
import 'package:ecommerce_admin_pannal/features/order/domain/repos/order_repo.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_cubit.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_detail_cubit/order_detail_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/repos/product_repo.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_attributes/product_attributes_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_image/product_image_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_variations/prduct_cariations_cubit.dart';
import 'package:ecommerce_admin_pannal/features/settings/data/repos/settings_repo_impl.dart';
import 'package:ecommerce_admin_pannal/features/settings/presentation/controller/settings_cubit/settings_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/data_source/email_auth-datasource_imple.dart';
import '../../features/auth/data/data_source/email_auth_datasource.dart';
import '../../features/auth/data/data_source/profile_datasource_imple.dart';
import '../../features/auth/data/data_source/reset_password_datasource.dart';
import '../../features/auth/data/data_source/reset_password_datasource_imple.dart';
import '../../features/auth/data/data_source/session_datasource.dart';
import '../../features/auth/data/data_source/session_datasource_imple.dart';
import '../../features/auth/data/data_source/social_auth_datasource.dart';
import '../../features/auth/data/data_source/social_auth_datasource_imple.dart';
import '../../features/auth/data/data_source/verify_email_datasource.dart';
import '../../features/auth/data/data_source/verify_email_datasource_imple.dart';
import '../../features/auth/data/repos/email_auth-repo_imple.dart';
import '../../features/auth/data/repos/reset_password_repo_imple.dart';
import '../../features/auth/data/repos/session_repo_imple.dart';
import '../../features/auth/data/repos/social_auth_repo_imple.dart';
import '../../features/auth/data/repos/verify_email_repo_imple.dart';
import '../../features/auth/domain/repos/email_auth_repo.dart';
import '../../features/auth/domain/repos/profile_repo.dart';
import '../../features/auth/domain/repos/reset_password_repo.dart';
import '../../features/auth/domain/repos/session_repo.dart';
import '../../features/auth/domain/repos/social_auth_repo.dart';
import '../../features/auth/domain/repos/verify_email_repo.dart';
import '../../features/auth/presentation/bloc/email_auth_bloc/email_auth_bloc.dart';
import '../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../features/auth/presentation/cubit/reset_password_cubit/reset_password_cubit.dart';
import '../../features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import '../../features/auth/presentation/cubit/social_auth-bloc/social_auth_cubit.dart';
import '../../features/auth/presentation/cubit/verify_email_cubit/verify_email_cubit.dart';
import '../../features/banner/data/repos/banner_repo_impl.dart';
import '../../features/banner/presentation/controller/create_banner/create_banner_cubit.dart';
import '../../features/banner/presentation/controller/edit_banner/edit_banner_cubit.dart';
import '../../features/brand/presentation/controller/create_brand/create_brand_cubit.dart';
import '../../features/brand/presentation/controller/edit_brand/edit_brand_cubit.dart';
import '../../features/categories/presentation/controller/create_category/create_category_cubit.dart';
import '../../features/categories/presentation/controller/edit_category/edit_category_cubit.dart';
import '../../features/order/data/repos/user_repo_impl.dart';
import '../../features/order/domain/repos/user_repo.dart';
import '../../features/product/data/repos/product_repo_impl.dart';
import '../../features/product/presentation/controller/create_product/create_product_cubit.dart';
import '../../features/product/presentation/controller/edit_product/edit_product_cubit.dart';
import '../../features/product/presentation/controller/product_cubit.dart';
import '../../features/settings/domain/repos/settings_repo.dart';
import '../network/firebase/auth_client.dart';
import '../network/firebase/auth_client_imple.dart';
import '../network/firebase/cloud_firestore.dart';
import '../network/firebase/database_services.dart';
import '../network/firebase/storage_service.dart';
import '../network/firebase/supabase_storage.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<AuthClient>(
    () => AuthClientImpl(FirebaseAuth.instance),
  );

  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  sl.registerLazySingleton<SupabaseStorageClient>(
    () => Supabase.instance.client.storage,
  );
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
  sl.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);
  sl.registerLazySingleton<DatabaseServices>(
    () => CloudFirestore(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<StorageService>(() => SupabaseStorageService(sl()));
  sl.registerLazySingleton<EmailAuthDatasource>(
    () => EmailAuthdatasourceImple(authClient: sl()),
  );
  sl.registerLazySingleton<VerifyEmailDatasource>(
    () => VerifyEmailDatasourceImple(authClient: sl()),
  );
  sl.registerLazySingleton<SessionDataSource>(
    () => SessionDatasourceImple(authClient: sl()),
  );
  sl.registerLazySingleton<ProfileDatasource>(
    () => ProfileDatasourceImple(sl(), storageService: sl(), authClient: sl()),
  );
  sl.registerLazySingleton<SocialAuthDatasource>(
    () => SocialAuthDataSourceImpl(
      authClient: sl(),
      googleSignIn: sl(),
      facebookAuth: sl(),
    ),
  );
  // sl.registerLazySingleton<ProfileDatasource>(
  //       () =>  ProfileDatasource(sl(), authClient: sl(), storageService: sl()),
  // );
  sl.registerLazySingleton<ResetPasswordDatasource>(
    () => ResetPasswordDatasourceImple(authClient: sl()),
  );
  sl.registerLazySingleton<EmailAuthRepo>(
    () => EmailAuthRepoImple(emailAuthDatasource: sl(), databaseServices: sl()),
  );

  sl.registerLazySingleton<VerifyEmailRepo>(
    () => VerifyEmailRepoImple(verifyEmailDatasource: sl()),
  );

  sl.registerLazySingleton<SessionRepo>(
    () => SessionRepositoryImpl(sessionDataSource: sl()),
  );
  sl.registerLazySingleton<SocialAuthRepo>(
    () =>
        SocialAuthRepoImple(databaseServices: sl(), socialAuthDatasource: sl()),
  );
  sl.registerLazySingleton<ResetPasswordRepo>(
    () => ResetPasswordRepoImple(resetPasswordDatasource: sl()),
  );

  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImple(profileDatasource: sl(), databaseServices: sl()),
  );
  sl.registerLazySingleton<CategoryRepo>(
    () => CategoryRepoImpl(databaseServices: sl()),
  );
  sl.registerLazySingleton<BrandRepo>(
    () => BrandRepoImpl(databaseServices: sl()),
  );
  sl.registerLazySingleton<BannerRepo>(
    () => BannerRepoImpl(databaseServices: sl()),
  );
  sl.registerLazySingleton<ProductRepo>(
    () => ProductRepoImpl(databaseServices: sl()),
  );
  sl.registerLazySingleton<UserRepo>(
    () => UserRepoImpl(databaseServices: sl()),
  );
  sl.registerLazySingleton<AddressRepo>(() => AddressRepositoryImpl());
  sl.registerLazySingleton<OrderRepo>(
    () => OrderRepoImpl(databaseServices: sl()),
  );
  sl.registerLazySingleton<SettingsRepo>(() => SettingsRepoImpl());
  sl.registerLazySingleton<MediaRepo>(
    () => MediaRepositoryImple(storageService: sl(), databaseServices: sl()),
  );

  sl.registerFactory<EmailAuthBloc>(
    () => EmailAuthBloc(emailAuthRepo: sl<EmailAuthRepo>(), settingsRepo: sl()),
  );
  sl.registerFactory<VerifyEmailCubit>(
    () => VerifyEmailCubit(verifyEmailRepo: sl()),
  );
  sl.registerFactory<SessionCubit>(() => SessionCubit(sessionRepository: sl()));
  sl.registerFactory<SocialAuthCubit>(
    () => SocialAuthCubit(socialAuthRepo: sl()),
  );
  sl.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(resetPasswordRepo: sl()),
  );
  sl.registerFactory<UserCubit>(() => UserCubit(personalizationRepo: sl()));
  sl.registerFactory<MediaCubit>(() => MediaCubit(mediaRepository: sl()));

  sl.registerFactory<ProductImagesCubit>(() => ProductImagesCubit());
  sl.registerFactory<CategoryCubit>(() => CategoryCubit(categoryRepo: sl()));
  sl.registerFactory<CreateCategoryCubit>(
    () => CreateCategoryCubit(categoryRepo: sl()),
  );
  sl.registerFactory<EditCategoryCubit>(
    () => EditCategoryCubit(categoryRepo: sl()),
  );
  sl.registerFactory<BrandCubit>(
    () => BrandCubit(brandRepo: sl(), categoryCubit: sl()),
  );
  sl.registerFactory<CreateBrandCubit>(() => CreateBrandCubit(brandRepo: sl()));
  sl.registerFactory<EditBrandCubit>(() => EditBrandCubit(brandRepo: sl()));
  sl.registerFactory<BannerCubit>(() => BannerCubit(bannerRepo: sl()));
  sl.registerFactory<CreateBannerCubit>(
    () => CreateBannerCubit(bannerRepo: sl()),
  );
  sl.registerFactory<EditBannerCubit>(() => EditBannerCubit(bannerRepo: sl()));
  sl.registerFactory<ProductCubit>(() => ProductCubit(productRepo: sl()));
  sl.registerFactory<CreateProductCubit>(
    () => CreateProductCubit(
      productRepo: sl(),
      productVariationsCubit: sl(),
      productAttributesCubit: sl(),
      productCubit: sl(),
    ),
  );
  sl.registerFactory<EditProductCubit>(
    () => EditProductCubit(
      productRepo: sl(),
      productVariationsCubit: sl(),
      productImagesCubit: sl(),
      productAttributesCubit: sl(),
      productCubit: sl(),
      categoryCubit: sl(),
      brandCubit: sl(),
    ),
  );
  sl.registerFactory<ProductVariationsCubit>(() => ProductVariationsCubit());
  sl.registerFactory<ProductAttributesCubit>(() => ProductAttributesCubit());
  sl.registerFactory<OrderCubit>(() => OrderCubit(sl()));
  sl.registerFactory<CustomerCubit>(() => CustomerCubit(userRepo: sl()));
  sl.registerFactory<CustomerDetailCubit>(
    () => CustomerDetailCubit(userRepo: sl(), addressRepo: sl()),
  );
  sl.registerFactory<OrderDetailCubit>(
    () => OrderDetailCubit(userRepository: sl()),
  );
  sl.registerFactory<SettingsCubit>(
    () => SettingsCubit(sl(), mediaCubit: sl()),
  );
  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(orderRepo: sl(), userRepo: sl()),
  );
}
