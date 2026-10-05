import 'package:ecommerce_admin_pannal/common/abstraction/base_data_table/base_data_table_state.dart';
import 'package:ecommerce_admin_pannal/features/brand/domain/entities/brand_entity.dart';
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
    return RoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: Sizes.sm),
            Text(
              'Edit Brand',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            TextFormField(
              controller: nameController,
              validator: (value) => Validator.validateEmptyText('Name', value),
              decoration: const InputDecoration(
                labelText: 'Brand Name',
                prefixIcon: Icon(Iconsax.box),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            Text(
              'Select Categories',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields / 2),
            BlocBuilder<CategoryCubit, BaseDataTableState<CategoryEntity>>(
              builder: (context, categoryState) {
                return BlocBuilder<EditBrandCubit, EditBrandState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: Sizes.sm,
                      children: categoryState.allItems.map((element) {
                        final bool isSelected = state.selectedCategories.any(
                          (c) => c.id == element.id,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Sizes.sm),
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
            const SizedBox(height: Sizes.spaceBtwInputFields * 2),

            BlocBuilder<EditBrandCubit, EditBrandState>(
              builder: (context, state) {
                return ImageUploader(
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
            const SizedBox(height: Sizes.spaceBtwInputFields),

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
            const SizedBox(height: Sizes.spaceBtwInputFields * 2),

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
            const SizedBox(height: Sizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
