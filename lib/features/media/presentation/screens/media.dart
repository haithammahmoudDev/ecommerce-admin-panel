import 'package:ecommerce_admin_pannal/features/media/presentation/screens/responsive_screens/media_desktop.dart';
import 'package:ecommerce_admin_pannal/features/media/presentation/screens/responsive_screens/media_mobile.dart';
import 'package:ecommerce_admin_pannal/features/media/presentation/screens/responsive_screens/media_tablet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/di/injection_container.dart';
import '../../../../common/widgets/layouts/templates/site_layout.dart';
import '../controller/media_cubit/media_cubit.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(desktop: MediaDesktopScreen());
  }
}
