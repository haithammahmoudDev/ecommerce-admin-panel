import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../data/models/category_model.dart';
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
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Update Category',
                breadcrumbItems: ['/categories', 'Update Category'],
              ), // TBreadcrumbsWithHeading
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditCategoryForm(category: category),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}