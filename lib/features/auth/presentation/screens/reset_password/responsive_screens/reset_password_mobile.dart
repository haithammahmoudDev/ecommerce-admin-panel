import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/reset_password_widget.dart';

class ResetPasswordScreenMobile extends StatelessWidget {
  // 1. استقبال الـ email هنا وتمريره كـ required
  const ResetPasswordScreenMobile({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          // 2. تمرير الـ email إلى الـ Widget الداخلي (ResetPasswordWidget)
          child: ResetPasswordWidget(email: email),
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
