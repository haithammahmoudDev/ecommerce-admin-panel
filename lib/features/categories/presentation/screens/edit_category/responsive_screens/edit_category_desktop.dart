import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/create_category/widgets/create_category_form.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/edit_category/widgets/edit_category_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../utils/constants/sizes.dart';

import 'package:flutter/material.dart';

import '../../../../data/models/category_model.dart';
import '../../../../domain/entities/category_entity.dart';
// قم بإضافة الاستيرادات الخاصة بـ TSizes و TRoutes و TBreadcrumbsWithHeading و CategoryModel و EditCategoryForm هنا حسب مسارات مشروعك

class EditCategoryDesktopScreen extends StatelessWidget {
  const EditCategoryDesktopScreen({super.key, required this.category});

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
