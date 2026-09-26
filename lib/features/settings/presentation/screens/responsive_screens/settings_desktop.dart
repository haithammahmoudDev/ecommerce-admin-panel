import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../widgets/image_meta.dart';
import '../widgets/setting_form.dart';


class SettingsDesktopScreen extends StatelessWidget {
  const SettingsDesktopScreen({super.key});

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

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Pic and Meta
                  Expanded(child: ImageAndMeta()),
                  SizedBox(width: TSizes.spaceBtwSections),

                  // Form
                  Expanded(flex: 2, child: SettingsForm()),
                ],
              ) // Row
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
