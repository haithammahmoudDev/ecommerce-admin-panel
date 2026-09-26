import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/edit_product/edit_product_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_image/product_image_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../data/models/product_model.dart';
import 'esponsive_screens/edit_product_desktop.dart';
import 'esponsive_screens/edit_product_mobile.dart';
import 'esponsive_screens/edit_product_tablet.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    // 1. إنشاء الـ EditProductCubit وتهيئته
    final editProductCubit = sl<EditProductCubit>()..initProductData(product);

    return MultiBlocProvider(
      providers: [
        // 2. توفير الـ EditProductCubit
        BlocProvider.value(value: editProductCubit),

        BlocProvider.value(value: editProductCubit.productCategoriesCubit),
        BlocProvider.value(value: editProductCubit.productImagesCubit),
        BlocProvider.value(value: editProductCubit.productVariationsCubit),
        BlocProvider.value(value: editProductCubit.productAttributesCubit),
      ],
      child: SiteTemplate(
        mobile: EditProductMobileScreen(product: product),
        desktop: EditProductDesktopScreen(product: product),
        tablet: EditProductTabletScreen(product: product),
      ),
    );
  }
}