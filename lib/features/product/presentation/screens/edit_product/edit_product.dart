import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/edit_product/edit_product_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/screens/edit_product/responsive_screens/edit_product_desktop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final editProductCubit = sl<EditProductCubit>()..initProductData(product);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: editProductCubit),

        BlocProvider.value(value: editProductCubit.productCategoriesCubit),
        BlocProvider.value(value: editProductCubit.productImagesCubit),
        BlocProvider.value(value: editProductCubit.productVariationsCubit),
        BlocProvider.value(value: editProductCubit.productAttributesCubit),
      ],
      child: SiteTemplate(desktop: EditProductDesktopScreen(product: product)),
    );
  }
}
