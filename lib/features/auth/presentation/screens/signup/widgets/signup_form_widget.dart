
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/signup/widgets/terms_and_condition_oncheckbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/form/custom_form_field.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../../../bloc/email_auth_bloc/email_auth_bloc.dart';
import '../verify_email.dart';

class SignUpFormWidget extends StatelessWidget {
  SignUpFormWidget({super.key});
  bool privacyPolicy = false;
  final email = TextEditingController(); // Controller for email input
  final fullName = TextEditingController(); // Controller for username input
  final password = TextEditingController(); // Controller for password input
  final phoneNumber =
      TextEditingController(); // Controller for phone number input
  GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocListener<EmailAuthBloc, EmailAuthState>(
          listener: (context, state) {
            if (state is EmailAuthLoading) {
              TFullScreenLoader.openLoadingDialog(
                'we are processing your information....',
                TImages.docerAnimation,
                context,
              );
            }

            if (state is EmailAuthFailure) {
               TFullScreenLoader.stopLoading(context); // ✅ إغلاق الـ Loader أولاً عند الفشل
              TLoaders.errorSnackBar(
                title: 'Error',
                message: state.errorMessage, // تأكد من استقبال المتغير الفعلي من الـ State
                context: context,
              );
            }

            if (state is EmailAuthSuccess) {
              TFullScreenLoader.stopLoading(context); // ✅ إغلاق الـ Loader عند النجاح
              TLoaders.successSnackBar(
                title: 'Success',
                message: 'Your account has been created successfully! Please verify your email.',
                context: context,
              );
              context.pushNamed(
                VerifyEmailScreen.routeName,
                queryParameters: {'email': email.text.trim()},
              );         }

          },
         child: Container(
          padding: const EdgeInsets.only(
            top: Sizes.xl - 15,
            bottom: Sizes.xl,
          ),
          child: Form(
            key: _signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFormfieldWidget.withdownEar(
                  label: TTexts.tFullName,
                  controller: fullName,
                  prefixIcon: Icon(LineAwesomeIcons.user),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Full name must be at least 3 characters';
                    }
                    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
                    if (!nameRegex.hasMatch(value.trim())) {
                      return 'Full name can only contain letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Sizes.xl - 20),
                CustomFormfieldWidget.withdownEar(
                  label: TTexts.tEmail,
                  controller: email,
                  prefixIcon: Icon(LineAwesomeIcons.envelope),
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
                const SizedBox(height: Sizes.xl - 20),
                CustomFormfieldWidget.withdownEar(
                  label: TTexts.tPhoneNo,
                  controller: phoneNumber,
                  prefixIcon: Icon(LineAwesomeIcons.phone_solid),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
                      return 'Enter a valid phone number';
                    }
                    final phoneRegex = RegExp(r'^[\d\s\-\+\(\)]+$');
                    if (!phoneRegex.hasMatch(value.trim())) {
                      return 'Phone number contains invalid characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Sizes.xl - 20),
                CustomFormfieldWidget(
                  label: TTexts.tPassword,
                  controller: password,
                  prefixIcon: Icon(Icons.fingerprint),
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
                const SizedBox(height: Sizes.xl - 10),
                TermsAndConditionOncheckbox(
                  valueChanged: (bool value) => privacyPolicy = value,
                ),
                const SizedBox(height: Sizes.xl - 10),
                BlocBuilder<EmailAuthBloc, EmailAuthState>(
                  builder: (context, state) {
                    return TPrimaryButton(
                      // ✅ جعل الزر يتحول لشكل التحميل تلقائياً عندما تكون الحالة EmailAuthLoading
                      isLoading: state is EmailAuthLoading,
                      text: TTexts.tSignup.tr,
                      onPressed: () {
                        if (_signupFormKey.currentState!.validate()) {
                           if (!privacyPolicy) {
                            TLoaders.warningSnackBar(
                              title: 'Accept Privacy Policy',
                              message: 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.',
                              context: context,
                            );
                            return;
                          }
                          context.read<EmailAuthBloc>().add(
                            SignUpWithEmailEvent(
                              userName: fullName.text.trim(),
                              email: email.text.trim(),
                              password: password.text.trim(),
                              phoneNumber: phoneNumber.text.trim(),
                            ),
                          );
                        }
                      },
                    );
                  },
                )

              ],
            ),
          ),
        ),
);
      },
    );
  }
}
