 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/buttons/clickable_richtext_widget.dart';
import '../../../../../common/widgets/form/form_divider_widget.dart';
import '../../../../../common/widgets/form/form_header_widget.dart';
import '../../../../../common/widgets/form/social_footer.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../bloc/email_auth_bloc/email_auth_bloc.dart';
import '../login/login_screen.dart';
import 'widgets/signup_form_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  static const routeName = 'signup_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmailAuthBloc>(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormHeaderWidget(
                    image: TImages.tWelcomeScreenImage,
                    title: TTexts.tSignUpTitle,
                    subTitle: TTexts.tSignUpSubTitle,
                    imageHeight: 0.1,
                  ),
                  SignUpFormWidget(),
                  ClickableRichTextWidget(
                    text1: TTexts.tAlreadyHaveAnAccount,
                    text2: TTexts.tLogin,
                      onPressed: () => context.pushReplacementNamed('login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
