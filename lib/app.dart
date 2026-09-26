
import 'package:ecommerce_admin_pannal/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_pannal/routes/app_routes.dart';
import 'package:ecommerce_admin_pannal/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Starter Template',
        debugShowCheckedModeBanner: false,
         themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
      routerConfig: appRouter,
        // onGenerateRoute: AppRoutes.onGenerateRoute,
        // initialRoute: LoginScreen.routeName,
      );
  }
}

class ResponsiveDesignScreen extends StatelessWidget {
  const ResponsiveDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate();
  }
}
