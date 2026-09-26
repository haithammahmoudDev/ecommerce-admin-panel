import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../widgets/form.dart';
import '../widgets/image_meta.dart';


class ProfileDesktopScreen extends StatelessWidget {
  const ProfileDesktopScreen({super.key});

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

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Pic and Meta
                  const Expanded(
                    child: ImageAndMeta(),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Form
                  Expanded(
                    flex: 2,
                    child: ProfileForm(),
                  ),
                ],
              ), // Row
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
