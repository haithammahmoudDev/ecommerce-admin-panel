import 'package:flutter/material.dart';

class TResponsiveWidget extends StatelessWidget {
  const TResponsiveWidget({
    super.key,
    required this.desktop,
    required this.tablet,
    required this.mobile,
  });

  final Widget desktop;

  final Widget tablet;

  final Widget mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop;
        } else if (constraints.maxWidth < 1100 && constraints.maxWidth >= 680) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
