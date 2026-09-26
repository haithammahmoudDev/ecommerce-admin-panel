import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../features/auth/presentation/cubit/social_auth-bloc/social_auth_cubit.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../routes/routes.dart';
import '../buttons/clickable_richtext_widget.dart';
import '../buttons/primary_button.dart';
import '../buttons/social_button.dart';

class SocialFooter extends StatelessWidget {
  const SocialFooter({
    super.key,
    this.text1 = TTexts.tDontHaveAnAccount,
    this.text2 = TTexts.tSignup,
    required this.onPressed,
  });

  final String text1;
  final String text2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: TSizes.defaultSpace * 1.5,
        bottom: TSizes.defaultSpace,
      ),
      child: Column(
        children: [
          TPrimaryButton(
              isLoading: false,
              text: '${TTexts.tConnectWith.tr} ${TTexts.tPhoneNumber.tr}',
              onPressed: () {}
          ),
          const SizedBox(height: 10),
          BlocBuilder<SocialAuthCubit, SocialAuthState>(
            builder: (context, state) {
              return TSocialButton(
                image: TImages.tGoogleLogo,
                background: TColors.googleBackgroundColor,
                foreground: TColors.googleForegroundColor,
                text: '${TTexts.tConnectWith.tr} ${TTexts.tGoogle.tr}',
                isLoading: state is SocialAuthLoading,
                onPressed: () {
                  context.read<SocialAuthCubit>().signInWithGoogle();
                },
              );
            },
          ),
          const SizedBox(height: TSizes.defaultSpace * 2),
          ClickableRichTextWidget(
            text1: text1.tr,
            text2: text2.tr,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}