import 'package:ecommerce_admin_pannal/features/media/presentation/screens/responsive_screens/media_desktop.dart';
import 'package:flutter/cupertino.dart';
import '../../../../common/widgets/layouts/templates/site_layout.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(desktop: MediaDesktopScreen());
  }
}
