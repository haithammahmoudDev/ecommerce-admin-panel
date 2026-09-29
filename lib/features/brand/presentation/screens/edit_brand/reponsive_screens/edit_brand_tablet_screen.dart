import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/brand_entity.dart';
import '../widgets/edit_brand_form.dart';

class EditBrandTabletScreen extends StatelessWidget {
  const EditBrandTabletScreen({super.key, required this.brand});
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
              Text(
                'Edit Brand',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              EditBrandForm(brand: brand),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}

