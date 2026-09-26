import 'package:flutter/material.dart';

/// Widget for displaying different layouts based on screen size
class TResponsiveWidget extends StatelessWidget {
  const TResponsiveWidget({super.key, required this.desktop, required this.tablet, required this.mobile});

  /// Widget for desktop layout
  final Widget desktop;

  /// Widget for tablet layout
  final Widget tablet;

  /// Widget for mobile layout
  final Widget mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        // 💡 التحديث الهندسي: جعل الـ Desktop يبدأ من 1100 بكسل فما فوق
        // لكي يثبت الـ Sidebar وتظهر كروت الداشبورد متناسقة تماماً على اللاب توب الصغير
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
