import 'package:ecommerce_admin_pannal/common/widgets/layouts/headers/header.dart';
import 'package:ecommerce_admin_pannal/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:flutter/material.dart';

class TabletLayout extends StatelessWidget {
    TabletLayout({super.key, this.body});
   final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Sidebar(),
      appBar: HeaderCustom(scaffoldKey: scaffoldKey,),
      body: body ?? const SizedBox(),
    );
  }
}