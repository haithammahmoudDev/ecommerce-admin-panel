import 'package:dartz/dartz.dart' as brand;
import 'package:ecommerce_admin_pannal/common/abstraction/base_data_table/base_data_table_state.dart';
import 'package:ecommerce_admin_pannal/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_pannal/features/brand/data/models/brand_model.dart';
import 'package:ecommerce_admin_pannal/features/brand/domain/entities/brand_entity.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/brand_cubit.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/create_brand/create_brand_cubit.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../../categories/domain/entities/category_entity.dart';
import '../../../../../categories/presentation/screens/create_category/widgets/image_uploader.dart';
import '../../../controller/edit_brand/edit_brand_cubit.dart';

class EditBrandForm extends StatefulWidget {
  const EditBrandForm({super.key, required this.brand});
  final BrandEntity brand;

  @override
  State<EditBrandForm> createState() => _EditBrandFormState();
}

class _EditBrandFormState extends State<EditBrandForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.brand.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: TSizes.sm),
            Text(
              'Edit Brand',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: nameController,
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(
                labelText: 'Brand Name',
                prefixIcon: Icon(Iconsax.box),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Categories Selection
            Text(
              'Select Categories',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            // FIX: nested BlocBuilder so this rebuilds both when the master
            // category list arrives from CategoryCubit AND when the user
            // toggles a selection in EditBrandCubit. A single
            // `context.read<CategoryCubit>()` inside a BlocBuilder that only
            // listens to EditBrandCubit does NOT rebuild when CategoryCubit
            // emits later — that's why the chip list was rendering empty.
            BlocBuilder<CategoryCubit, BaseDataTableState<CategoryEntity>>(
              builder: (context, categoryState) {
                return BlocBuilder<EditBrandCubit, EditBrandState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: TSizes.sm,
                      children: categoryState.allItems.map((element) {
                        final bool isSelected = state.selectedCategories
                            .any((c) => c.id == element.id); // id-based, safer than .contains
                        return Padding(
                          padding: const EdgeInsets.only(bottom: TSizes.sm),
                          child: TChoiceChip(
                            text: element.name,
                            selected: isSelected,
                            onSelected: (value) => context
                                .read<EditBrandCubit>()
                                .selectParentCategory(element),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Image Uploader
            BlocBuilder<EditBrandCubit, EditBrandState>(
              builder: (context, state) {
                return TImageUploader(
                  height: 80,
                  width: 80,
                  image: state.imageUrl.isEmpty
                      ? widget.brand.image
                      : state.imageUrl,
                  imageType: ImageType.network,
                  onIconButtonPressed: () =>
                      context.read<EditBrandCubit>().pickImage(context),
                );
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Checkbox
            BlocBuilder<EditBrandCubit, EditBrandState>(
              builder: (context, state) {
                return CheckboxMenuButton(
                  value: state.isFeatured ?? widget.brand.isFeatured,
                  onChanged: (value) =>
                      context.read<EditBrandCubit>().toggleFeatured(value),
                  child: const Text('Featured'),
                );
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<EditBrandCubit>().editBrand(
                      nameController: nameController,
                      context: context,
                      id: widget.brand.id,
                      brand: widget.brand,
                    );
                  }
                },
                child: const Text('Update'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}