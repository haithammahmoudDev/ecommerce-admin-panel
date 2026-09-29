import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../domain/entities/brand_entity.dart';
import '../widgets/edit_brand_form.dart';

class EditBrandMobileScreen extends StatelessWidget {
  const EditBrandMobileScreen({super.key,required this.brand});
  final BrandEntity brand;

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
              Text(
                'Edit Brand',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              // Form
              EditBrandForm(brand: brand),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}

