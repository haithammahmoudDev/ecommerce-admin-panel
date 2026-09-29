import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_brand_form.dart';

class CreateBrandMobileScreen extends StatelessWidget {
  const CreateBrandMobileScreen({super.key});

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
                'Create Brand',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              // Form
              const CreateBrandForm(),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
