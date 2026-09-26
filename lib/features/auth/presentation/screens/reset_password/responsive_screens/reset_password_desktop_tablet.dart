import 'package:ecommerce_admin_pannal/common/widgets/layouts/templates/login_template.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/reset_password/widgets/reset_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ResetPasswordScreenDesktopTablet extends StatelessWidget {
  ResetPasswordScreenDesktopTablet({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(
      child: ResetPasswordWidget(email: email),
    ); // TLoginTemplate
  }
}

