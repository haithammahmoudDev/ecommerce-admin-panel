import 'package:ecommerce_admin_pannal/common/widgets/responsive/responsive_design.dart';
import 'package:ecommerce_admin_pannal/common/widgets/responsive/screens/desktop_layout.dart';
import 'package:ecommerce_admin_pannal/common/widgets/responsive/screens/mobile_layout.dart';
import 'package:ecommerce_admin_pannal/common/widgets/responsive/screens/tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SiteTemplate extends StatelessWidget {
  const SiteTemplate({
    super.key,
    this.desktop,
    this.tablet,
    this.mobile,
    this.useLayout = true,
    this.navigationShell, // 💡 إضافة معامل الـ Shell الاختياري هنا للربط مع الـ Router
  });

  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;
  final bool useLayout;
  final StatefulNavigationShell? navigationShell; // 💡 تعريف متغير الـ Shell

  @override
  Widget build(BuildContext context) {
    // 💡 الفكرة الذكية: إذا كان التطبيق يستخدم الـ ShellRoute (لوحة التحكم)، سنعرض الـ navigationShell
    // المحفوظة في الذاكرة تلقائياً لكل الشاشات، وإذا كان تنقلاً عادياً نستخدم الويدجتس الممررة قديماً.
    final Widget activeBody = navigationShell ?? desktop ?? const SizedBox.shrink();

    return Scaffold(
      body: TResponsiveWidget(
        desktop: useLayout
            ? DesktopLayout(body: activeBody)
            : activeBody,
        tablet: useLayout
            ? TabletLayout(body: navigationShell ?? tablet ?? desktop ?? const SizedBox.shrink())
            : (tablet ?? desktop ?? const SizedBox.shrink()),
        mobile: useLayout
            ? MobileLayout(body: navigationShell ?? mobile ?? desktop ?? const SizedBox.shrink())
            : (mobile ?? desktop ?? const SizedBox.shrink()),
      ),
    );
  }
}
