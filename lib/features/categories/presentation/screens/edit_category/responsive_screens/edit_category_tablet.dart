import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/category_entity.dart';
import '../widgets/edit_category_form.dart';

class EditCategoriesTabletScreen extends StatelessWidget {
  const EditCategoriesTabletScreen({super.key, required this.category});
  final CategoryEntity category;

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
                'Edit Category',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              // Form
              EditCategoryForm(category: category),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}