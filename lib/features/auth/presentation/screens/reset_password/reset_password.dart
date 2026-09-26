import 'package:ecommerce_admin_pannal/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/reset_password/responsive_screens/reset_password_desktop_tablet.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/reset_password/responsive_screens/reset_password_mobile.dart';
import 'package:flutter/cupertino.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});
  static const routeName = 'reset-password';
  final String email;
  @override
  Widget build(BuildContext context) {
    return SiteTemplate(useLayout: false, desktop: ResetPasswordScreenDesktopTablet(email: email,),
      mobile: ResetPasswordScreenMobile(email: email,),);
  }
}
