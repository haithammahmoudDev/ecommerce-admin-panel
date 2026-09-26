import 'package:ecommerce_admin_pannal/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/forget_password/resonsive_screens/forget_password_desktop_tablet.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/forget_password/resonsive_screens/forget_password_mobile.dart';
import 'package:flutter/cupertino.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});
   static const routeName = 'forget-password';
  @override
  Widget build(BuildContext context) {
    return SiteTemplate(useLayout: false, desktop: ForgetPasswordScreenDesktopTablet(),
      mobile: ForgetPasswordScreenMobile(),);
  }
}
