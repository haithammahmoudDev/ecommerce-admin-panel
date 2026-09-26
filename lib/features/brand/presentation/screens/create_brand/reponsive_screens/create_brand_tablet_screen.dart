import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_brand_form.dart';

class CreateBrandTabletScreen extends StatelessWidget {
  const CreateBrandTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Create Brand',
                breadcrumbItems: ['/categories', 'Create Brand'],
              ), // TBreadcrumbsWithHeading
              SizedBox(height: TSizes.spaceBtwSections),

              // Form
              CreateBrandForm(),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
