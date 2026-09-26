 import 'package:ecommerce_admin_pannal/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/bloc/email_auth_bloc/email_auth_bloc.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/login/responsive_screen/login_desktop_tablet.dart';
import 'package:ecommerce_admin_pannal/features/auth/presentation/screens/login/responsive_screen/login_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';

class LoginScreen extends StatelessWidget {
   const LoginScreen({super.key});
  static const routeName = 'login';
   @override
   Widget build(BuildContext context) {
     return BlocProvider(
  create: (context) => sl<EmailAuthBloc>(),
  child: SiteTemplate(useLayout: false, desktop: LoginScreenDesktopTablet(), mobile: const LoginScreenMobile(),),
);
   }
 }
