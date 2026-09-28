import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../categories/presentation/screens/create_category/widgets/image_uploader.dart';
import '../../controller/settings_cubit/settings_cubit.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return RoundedContainer(
      padding: const EdgeInsets.symmetric(vertical: TSizes.lg, horizontal: TSizes.md),
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.status == SettingsStatus.success) {
            TLoaders.successSnackBar(title: 'Updated', context: context,
                message: 'App Settings updated successfully!');
          }
          if (state.status == SettingsStatus.error) {
            TLoaders.errorSnackBar(title: 'Updated Error', context: context,
                message: 'Failed to update settings');
          }
        },
        child: Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Settings', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: TSizes.spaceBtwSections),
              // App Name Input Field
              TextFormField(
                controller: cubit.appNameController,
                validator: (value) => TValidator.validateEmptyText('App Name', value),
                decoration: const InputDecoration(
                  hintText: 'App Name',
                  label: Text('App Name'),
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Tax, Shipping, & Free Shipping Threshold Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cubit.taxController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => TValidator.validateEmptyText('Tax Rate', value),
                      decoration: const InputDecoration(
                        hintText: 'Tax %',
                        label: Text('Tax Rate (%)'),
                        prefixIcon: Icon(Iconsax.tag),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TextFormField(
                      controller: cubit.shippingController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => TValidator.validateEmptyText('Shipping Cost', value),
                      decoration: const InputDecoration(
                        hintText: 'Shipping Cost',
                        label: Text('Shipping Cost (\$)'),
                        prefixIcon: Icon(Iconsax.ship),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TextFormField(
                      controller: cubit.freeShippingThresholdController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => TValidator.validateEmptyText('Free Shipping Threshold', value),
                      decoration: const InputDecoration(
                        hintText: 'Free Shipping After (\$)',
                        label: Text('Free Shipping Threshold (\$)'),
                        prefixIcon: Icon(Iconsax.ship),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields * 2),

              // ---------------------------------------------------------------
              // SELECTOR #2: Form Submit Button Loading State (Isolated Rebuild)
              // ---------------------------------------------------------------
              BlocSelector<SettingsCubit, SettingsState, bool>(
                selector: (state) => state.isFormLoading,
                builder: (context, isFormLoading) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isFormLoading ? null : () => cubit.updateSettingInformation(),
                      child: isFormLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text('Update App Settings'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}