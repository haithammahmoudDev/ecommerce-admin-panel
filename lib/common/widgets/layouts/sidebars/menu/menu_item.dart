import 'package:ecommerce_admin_pannal/common/widgets/layouts/sidebars/cubit/sidebar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../cubit/sidebar_state.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.route,
    required this.itemName,
    required this.icon,
  });

  final String route, itemName;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final sidebarCubit = context.read<SidebarCubit>();

    return InkWell(
      onTap: () => sidebarCubit.menuOnTap(context, route),
      onHover: (hovering) => hovering
          ? sidebarCubit.changeHoverItem(route)
          : sidebarCubit.changeHoverItem(''),
      child: BlocBuilder<SidebarCubit, SidebarState>(
        builder: (context, state) {
          final isActive = state.isActive(route);
          final isHovering = state.isHovering(route);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs / 2),
            child: Container(
              decoration: BoxDecoration(
                color: isHovering || isActive
                    ? itemName != 'Logout' ? TColors.primary : Colors.red
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Padding(
                    padding: const EdgeInsets.only(
                      left: TSizes.lg,
                      top: TSizes.md,
                      bottom: TSizes.md / 2,
                      right: TSizes.md,
                    ),
                    child: isActive
                        ? Icon(icon, size: 22, color: TColors.white)
                        : Icon(
                      icon,
                      size: 22,
                      color: isHovering ? TColors.white : TColors.darkGrey,
                    ),
                  ), // Padding

                  // Text
                  if (isHovering || isActive)
                    Flexible(
                      child: Text(
                        itemName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: TColors.white),
                      ),
                    )
                  else
                    Flexible(
                      child: Text(
                        itemName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: TColors.darkGrey),
                      ),
                    ),
                ],
              ), // Row
            ),
          );
        },
      ),
    );
  }
}