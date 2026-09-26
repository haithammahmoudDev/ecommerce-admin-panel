import 'package:ecommerce_admin_pannal/common/widgets/layouts/templates/login_template.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/forget_password/widgets/header_and_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/form/custom_form_field.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/validators/validation.dart';

class ForgetPasswordScreenDesktopTablet extends StatelessWidget {
    ForgetPasswordScreenDesktopTablet({super.key});
  final TextEditingController email = TextEditingController(); //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(
      child: HeaderAndForm(formKey: _formKey, email: email,) // Column
    ); // TLoginTemplate
  }
}

