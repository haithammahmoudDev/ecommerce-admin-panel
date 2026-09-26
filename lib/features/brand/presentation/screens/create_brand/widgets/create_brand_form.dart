import 'package:ecommerce_admin_pannal/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/create_brand/create_brand_cubit.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/entities/category_entity.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/create_category/widgets/image_uploader.dart';

class CreateBrandForm extends StatefulWidget {
  const CreateBrandForm({super.key});

  @override
  State<CreateBrandForm> createState() => _CreateBrandFormState();
}

class _CreateBrandFormState extends State<CreateBrandForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateBrandCubit>();
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
            Text('Create New Brand', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال اسم البراند';
                }
                if (value.trim().length < 2) {
                  return 'اسم البراند لازم يكون حرفين على الأقل';
                }
                return null;
              },
              decoration: const InputDecoration(labelText: 'Brand Name', prefixIcon: Icon(Iconsax.box)),
            ), // TextFormField
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Categories Selection
            // Categories Selection
            Text('Select Categories', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            BlocBuilder<CategoryCubit, BaseDataTableState<CategoryEntity>>(
              builder: (context, categoryState) {
                // 1. الاستماع لتغيرات الفئات المحددة داخل CreateBrandCubit
                return BlocBuilder<CreateBrandCubit, CreateBrandState>(
                  builder: (context, brandState) {
                    return Wrap(
                      spacing: TSizes.sm,
                      children: categoryState.allItems.map((category) {
                        // 2. التحقق مما إذا كانت الفئة الحالية موجودة في القائمة المحددة
                        final isSelected = brandState.selectedCategories.contains(category);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: TSizes.sm),
                          child: TChoiceChip(
                            text: category.name,
                            selected: isSelected,
                            onSelected: (selected) {
                              cubit.selectParentCategory(category);
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // // Image Uploader
            BlocBuilder<CreateBrandCubit, CreateBrandState>(
             builder: (context, state) {
              return TImageUploader(
              height: 80,
              width: 80,
              image:state.imageUrl.isNotEmpty ? state.imageUrl :  'assets/images/profile/logo.png',
                imageType: state.imageUrl.isNotEmpty ? ImageType.network : ImageType.asset,
              onIconButtonPressed: ()=> context.read<CreateBrandCubit>().pickImage(context),
            );
  },
), // TImageUploader
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // //Checkbox
            BlocBuilder<CreateBrandCubit, CreateBrandState>(
  builder: (context, state) {
    return CheckboxMenuButton(
              value: state.isFeatured,
              onChanged: (value)=> context.read<CreateBrandCubit>().toggleFeatured(value),
              child: const Text('Featured'),
            );
  },
), // CheckboxMenuButton
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // //Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                    cubit.createBrand(nameController: nameController, context: context);
                },
                child: const Text('Create'),
              ),
            ), // SizedBox
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ), // Column
      ), // Form
    ); // TRoundedContainer
  }
}
