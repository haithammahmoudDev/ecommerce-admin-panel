import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/brand_cubit.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_attribute_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_attributes/product_attributes_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_variations/prduct_cariations_cubit.dart';
import 'package:ecommerce_admin_pannal/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_strategy/url_strategy.dart';

import 'app.dart';
import 'common/di/injection_container.dart';
import 'common/local_storage/local_storage.dart';
import 'common/preferences/preferences_manager.dart';
import 'common/preferences/save_user_by_hive.dart';

import 'common/widgets/layouts/sidebars/cubit/sidebar_cubit.dart';
import 'features/banner/presentation/controller/banner_cubit.dart';
import 'features/media/presentation/controller/media_cubit/media_cubit.dart';
import 'features/product/presentation/controller/product_cubit.dart';
import 'features/product/presentation/controller/product_image/product_image_cubit.dart';
import 'features/settings/presentation/controller/settings_cubit/settings_cubit.dart';
import 'firebase_options.dart';
import 'utils/helpers/network_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true; // ضيف هذا السطر
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLISHER_KEY']!,
  );
  await initDependencies();

  await TLocalStorage.init();
  await UserRepository().init();
  await PreferencesManager().init();

  // ⚠️ منع سلوك المتصفح الافتراضي عند سحب وإفلات ملف (فتحه في تاب جديد)
  // لازم يتحط قبل runApp عشان drag & drop في شاشة الـ Media يشتغل صح
  if (kIsWeb) {
    html.document.onDragOver.listen((event) => event.preventDefault());
    html.document.onDrop.listen((event) => event.preventDefault());
  }

  // 💡 تم دمج وتغليف التطبيق داخل دالة runApp البرمجية بشكل صحيح هنا ليعمل بنجاح
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SidebarCubit>(
          create: (context) {
            final String currentUrl =
                appRouter.routerDelegate.currentConfiguration.uri.path;
            return SidebarCubit(
              initialRoute: currentUrl.isEmpty ? '/dashboard' : currentUrl,
            );
          },
        ),

        BlocProvider<MediaCubit>(
          create: (_) => sl<MediaCubit>(),
        ),

        BlocProvider<CategoryCubit>(
          create: (_) => sl<CategoryCubit>(),
        ),

        BlocProvider<BrandCubit>(
          create: (_) => sl<BrandCubit>(),
        ),

        BlocProvider<BannerCubit>(
          create: (_) => sl<BannerCubit>(),
        ),

        BlocProvider<ProductCubit>(
          create: (_) => sl<ProductCubit>(),
        ),

        BlocProvider(
          create: (context) => sl<ProductImagesCubit>(),
        ),

        BlocProvider(
          create: (context) => sl<ProductVariationsCubit>(),
        ),

        BlocProvider(
          create: (context) => sl<ProductAttributesCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SettingsCubit>()..fetchSettingDetails(),
        ),
      ],
      child: const App(),
    ),
  );

}