import 'package:ecommerce_admin_pannal/common/widgets/layouts/headers/header.dart';
import 'package:ecommerce_admin_pannal/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:ecommerce_admin_pannal/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../custom_shapes/containers/rounded_container.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body});

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Row(
        children: [
          const Expanded(child: Sidebar()),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                 THeader(),
                 Expanded(child: body ?? const SizedBox()),
              ],
            ), // Column
          ), // Expanded
        ],
      ), // Row
    ); // Scaffold
  }
}
