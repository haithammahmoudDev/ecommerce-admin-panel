import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../widgets/form.dart';
import '../widgets/image_meta.dart';

class ProfileMobileScreen extends StatelessWidget {
  const ProfileMobileScreen({super.key});

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
                heading: 'Profile',
                breadcrumbItems: const ['Profile'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Body arranged vertically for mobile
              Column(
                children: [
                  const ImageAndMeta(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Form
                  ProfileForm(),
                ],
              ), // Column
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
