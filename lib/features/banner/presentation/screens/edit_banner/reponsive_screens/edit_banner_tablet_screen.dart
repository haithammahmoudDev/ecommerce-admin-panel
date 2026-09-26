import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../data/models/banner_model.dart';
import '../../../../domain/entities/banner_entity.dart';
import '../widgets/edit_banner_form.dart';

class EditBannerTabletScreen extends StatelessWidget {
  const EditBannerTabletScreen({super.key, required this.banner});
  final BannerEntity banner;

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
              TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Update Banner',
                breadcrumbItems: const ['/categories', 'Edit Banner'],
              ), // TBreadcrumbsWithHeading
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditBannerForm(banner: banner),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}

