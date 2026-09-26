import 'package:ecommerce_admin_pannal/features/auth/presentation/bloc/email_auth_bloc/email_auth_bloc.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/forget_password/forget_password.dart';
import 'package:ecommerce_admin_pannal/features/dashboard/presentation/screens/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/preferences/preferences_manager.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/form/custom_form_field.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../signup/verify_email.dart';
import '../login_screen.dart';
import '../widgets/remember_me_widget.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});
  final email = TextEditingController(); //
  final password = TextEditingController();
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailAuthBloc, EmailAuthState>(
      listener: (context, state) async {
        if (state is EmailAuthFailure) {
          TLoaders.errorSnackBar(
            title: 'Error',
            message: state.errorMessage,
            context: context,
          );
        }

        if (state is EmailNotVerified) {
          TLoaders.warningSnackBar(
            title: 'Warning',
            message: 'You must verify your email',
            context: context,
          );

          context.pushNamed(
            VerifyEmailScreen.routeName,
            queryParameters: {'email': email.text.trim()},
          );
        }

        if (state is EmailAuthSuccess) {
          await PreferencesManager().setBool('rememberMe', rememberMe);

          TLoaders.successSnackBar(
            title: 'Success',
            message: 'Your account has been logged in successfully!',
            context: context,
          );

          context.goNamed('dashboard');
        }
      },
      child: Form(
        key: _loginFormKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              CustomFormfieldWidget.withdownEar(
                label: TTexts.tEmail,
                controller: email,
                prefixIcon: Icon(Iconsax.direct_right),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              CustomFormfieldWidget(
                label: TTexts.tPassword,
                controller: password,
                prefixIcon: Icon(Iconsax.password_check),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return 'Password must contain an uppercase letter';
                  }
                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                    return 'Password must contain a lowercase letter';
                  }
                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return 'Password must contain a number';
                  }
                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                    return 'Password must contain a special character';
                  }
                  return null;
                },
                withdownEar: false,
              ),
              SizedBox(height: TSizes.spaceBtwInputFields / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RememberMe(valueChanged: (bool value) => rememberMe = value),
                  TextButton(
                    onPressed: () {
                      context.push('/forget');
                    },
                    child: const Text(TTexts.tForgetPassword),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              BlocBuilder<EmailAuthBloc, EmailAuthState>(
                builder: (context, state) {
                  return TPrimaryButton(
                    isLoading: state is EmailAuthLoading,
                    text: TTexts.tLogin.tr,
                    onPressed: (state is EmailAuthLoading)
                        ? () {}
                        : () async {
                            if (_loginFormKey.currentState!.validate()) {
                              context.read<EmailAuthBloc>().add(
                                SignInWithEmailEvent(
                                  email: email.text.trim(),
                                  password: password.text.trim(),
                                ),
                              );
                            }
                          },
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
