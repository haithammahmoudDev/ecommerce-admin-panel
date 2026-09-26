import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../widgets/image_meta.dart';
import '../widgets/setting_form.dart';

class SettingsMobileScreen extends StatelessWidget {
  const SettingsMobileScreen({super.key});

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
              TBreadcrumbsWithHeading(heading: 'Settings', breadcrumbItems: ['Settings']),
              SizedBox(height: TSizes.spaceBtwSections),

              // Body arranged vertically for mobile
              Column(
                children: [
                  ImageAndMeta(),
                  SizedBox(height: TSizes.spaceBtwSections),

                  SettingsForm(),
                ],
              ),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
