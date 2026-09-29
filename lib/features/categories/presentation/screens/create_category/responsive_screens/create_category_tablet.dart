import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/create_category/widgets/create_category_form.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';

class CreateCategoriesTabletScreen extends StatelessWidget {
  const CreateCategoriesTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Category',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              // Form
             const CreateCategoryForm(),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}