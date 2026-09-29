import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../data/models/product_model.dart';
import '../../../controller/edit_product/edit_product_cubit.dart';

class ProductBottomNavigationButtons extends StatelessWidget {
  const ProductBottomNavigationButtons({super.key, required this.product});
  final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Discard'),
          ),
          const SizedBox(width: Sizes.spaceBtwItems / 2),

          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: () => context.read<EditProductCubit>().editProduct(
                ProductModel.fromEntity(product),
                context,
              ),
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
