import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/form.dart';
import '../widgets/image_meta.dart';


class ProfileTabletScreen extends StatelessWidget {
  const ProfileTabletScreen({super.key});

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
                heading: 'Profile',
                breadcrumbItems: ['Profile'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Column(
                children: [
                  const ImageAndMeta(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Form
                  ProfileForm(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

