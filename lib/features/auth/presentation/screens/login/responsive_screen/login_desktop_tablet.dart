import 'package:ecommerce_admin_pannal/common/widgets/layouts/templates/login_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
    LoginScreenDesktopTablet({super.key});
  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(
      child: Column(
      children: [
        const LoginHeader(),
        LoginForm(),
      ],
    ),);
  }
}
