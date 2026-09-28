import 'package:ecommerce_admin_pannal/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/edit_category/edit_category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../data/models/category_model.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../controller/category/category_cubit.dart';
import '../../create_category/widgets/image_uploader.dart';

class EditCategoryForm extends StatefulWidget {
  const EditCategoryForm({super.key, required this.category});
  final CategoryEntity category;

  @override
  State<EditCategoryForm> createState() => _EditCategoryFormState();
}

class _EditCategoryFormState extends State<EditCategoryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditCategoryCubit>();
    return RoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: TSizes.sm),
            Text('Update New Category', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: nameController,
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(labelText: 'Category Name', prefixIcon: Icon(Iconsax.category)),
            ), // TextFormField

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            BlocBuilder<EditCategoryCubit, EditCategoryState>(
              builder: (context, state) {
                if (state.status == EditCategoryStatus.loading) {
                  return const TShimmerEffect(
                    width: double.infinity,
                    height: 55,
                  );
                }

                final categoriesList = context.read<CategoryCubit>().state.allItems;

                // Resolve the actual parent entity from parentId
                // (NOT widget.category itself — that is the category being edited)
                final initialParent = widget.category.parentId == null
                    ? CategoryEntity.empty
                    : categoriesList.firstWhere(
                      (cat) => cat.id == widget.category.parentId,
                  orElse: () => CategoryEntity.empty,
                );

                final currentValue = state.selectedParent == CategoryEntity.empty
                    ? initialParent
                    : state.selectedParent;

                // IMPORTANT: DropdownButtonFormField requires that `value`
                // matches EXACTLY ONE entry in `items`. Since our fallback
                // can be CategoryEntity.empty ("No Parent"), we must include
                // that as an actual item — otherwise Flutter throws:
                // "There should be exactly one item with [DropdownButton]'s value"
                final dropdownItems = <DropdownMenuItem<CategoryEntity>>[
                  const DropdownMenuItem<CategoryEntity>(
                    value: CategoryEntity.empty,
                    child: Text('No Parent'),
                  ),
                  ...categoriesList
                      .where((item) => item.id != widget.category.id) // prevent self-parenting
                      .map(
                        (item) => DropdownMenuItem<CategoryEntity>(
                      value: item,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item.name),
                        ],
                      ),
                    ),
                  ),
                ];

                return DropdownButtonFormField<CategoryEntity>(
                  decoration: InputDecoration(
                    hintText: 'Parent Category',
                    labelText: 'Parent Category',
                    prefixIcon: Icon(Iconsax.bezier),
                  ), // InputDecoration
                  value: currentValue,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      context.read<EditCategoryCubit>().selectParentCategory(newValue);
                    }
                  },
                  items: dropdownItems,
                );
              },
            ), // DropdownButtonFormField
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            BlocBuilder<EditCategoryCubit, EditCategoryState>(
              builder: (context, state) {
                return TImageUploader(
                  width: 80,
                  height: 80,
                  image: state.imageUrl.isNotEmpty
                      ? context.read<EditCategoryCubit>().state.imageUrl
                      : widget.category.image,
                  imageType: ImageType.network,
                  onIconButtonPressed: () => context.read<EditCategoryCubit>().pickImage(context),
                );
              },
            ), // TImageUploader
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // CheckboxMenuButton
            BlocBuilder<EditCategoryCubit, EditCategoryState>(
              builder: (context, state) {
                return CheckboxMenuButton(
                  value: state.isFeatured ?? widget.category.isFeatured,
                  onChanged: (value) {
                    context.read<EditCategoryCubit>().toggleFeatured(value);
                  },
                  child: const Text('Featured'),
                );
              },
            ), // CheckboxMenuButton
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cubit.editCategory(nameController: nameController, context: context,
                        id: CategoryModel.fromEntity(widget.category).id,
                    );
                  }
                },
                child: const Text('update'),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ), // Column
      ), // Form
    );
  }
}