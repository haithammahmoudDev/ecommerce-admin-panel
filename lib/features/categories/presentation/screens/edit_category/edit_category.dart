import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../domain/entities/category_entity.dart';
import '../../controller/edit_category/edit_category_cubit.dart';
import '../edit_category/responsive_screens/edit_category_desktop.dart';
import '../edit_category/responsive_screens/edit_category_mobile.dart';
import '../edit_category/responsive_screens/edit_category_tablet.dart';


class EditCategoryScreen extends StatelessWidget {
  const EditCategoryScreen({super.key, required this.category});
  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EditCategoryCubit>()..init(category),
      child: SiteTemplate(
        desktop: EditCategoryDesktopScreen(category: category),
        tablet: EditCategoriesTabletScreen(category: category),
        mobile: EditCategoryMobileScreen(category: category),
      ),
    );
  }
}