import 'package:ecommerce_admin_pannal/common/local_storage/local_storage_service.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../auth/domain/entities/user_entity.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
 late final UserEntity user;

  @override
  void initState() {
    super.initState();
    user = LocalStorageService.userRepo.getData()!.toEntity();
    nameController = TextEditingController(text: user.fullName ?? '');
    emailController = TextEditingController(text: user.email ?? '');
    phoneController = TextEditingController(text: user.phoneNumber ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedContainer(
          padding: const EdgeInsets.symmetric(
            vertical: TSizes.lg,
            horizontal: TSizes.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        label: Text('Full Name'),
                        prefixIcon: Icon(Iconsax.user),
                      ),
                      validator: (value) =>
                          TValidator.validateEmptyText('Full Name', value),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Email and Phone Row
                    Row(
                      children: [
                        // Email
                        Expanded(
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              label: Text('Email'),
                              prefixIcon: Icon(Iconsax.forward),
                              enabled: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),

                        // Phone Number
                        Expanded(
                          child: TextFormField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              label: Text('Phone Number'),
                              prefixIcon: Icon(Iconsax.mobile),
                            ),
                            validator: (value) =>
                                TValidator.validateEmptyText('Phone Number', value),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        // Update Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final currentUser = context.read<UserCubit>().state.user;

                if (nameController.text.trim() != currentUser?.fullName ||
                    phoneController.text.trim() != currentUser?.phoneNumber) {

                  context.read<UserCubit>().updateUserData(
                    user: currentUser!.copyWith(
                      fullName: nameController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                    ),
                  );
                }
              }
            },
            child: const Text('Update Profile'),
          ),
        ),
      ],
    );
  }
}