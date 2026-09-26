import 'package:ecommerce_admin_pannal/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_pannal/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/create_category/create_category_cubit.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/create_category/create_category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../domain/entities/category_entity.dart';
import 'image_uploader.dart';

class CreateCategoryForm extends StatefulWidget {
  const CreateCategoryForm({super.key});

  @override
  State<CreateCategoryForm> createState() => _CreateCategoryFormState();
}

class _CreateCategoryFormState extends State<CreateCategoryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateCategoryCubit>();
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
            Text('Create New Category', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please, Enter Category Name';
                }
                return null; // القيمة صحيحة
              },
              decoration: const InputDecoration(labelText: 'Category Name', prefixIcon: Icon(Iconsax.category)),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
              builder: (context, state) {
                if (state.status == CreateCategoryStatus.loading) {
                  return const TShimmerEffect(
                    width: double.infinity,
                    height: 55,
                  );
                }

                final categoriesList = context.read<CategoryCubit>().state.allItems;

                return DropdownButtonFormField<CategoryEntity>(
                  decoration: const InputDecoration(
                    hintText: 'Parent Category',
                    labelText: 'Parent Category',
                    prefixIcon: Icon(Iconsax.bezier),
                  ),
                  value: state.selectedParent == CategoryEntity.empty ? null : state.selectedParent,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      cubit.selectParentCategory(newValue);
                    }
                  },
                  items: categoriesList
                      .where((item) => item.parentId.isEmpty) // filter here
                      .map((item) {
                    return DropdownMenuItem<CategoryEntity>(
                      value: item,
                      child: Text(item.name),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
              builder: (context, state) {
                return TImageUploader(
                  width: 80,
                  height: 80,
                  image: state.imageUrl.isNotEmpty ? state.imageUrl : 'assets/images/profile/logo.png',
                  imageType: state.imageUrl.isNotEmpty ? ImageType.network : ImageType.asset,
                  onIconButtonPressed: () => context.read<CreateCategoryCubit>().pickImage(context),
                );
              },
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            // CheckboxMenuButton
            BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
              builder: (context, state) {
                return CheckboxMenuButton(
                  value: state.isFeatured,
                  onChanged: (value) => context.read<CreateCategoryCubit>().toggleFeatured(value),
                  child: const Text('Featured'),
                );
              },
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cubit.createCategory(
                      nameController: nameController,
                      context: context,
                    );
                  }
                },
                child: const Text('Create'),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}