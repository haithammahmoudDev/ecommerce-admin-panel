import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'sidebar_state.dart';

class SidebarCubit extends Cubit<SidebarState> {
  // استقبال المسار الابتدائي ديناميكياً ليدعم الـ Hot Reload والروابط المباشرة
  SidebarCubit({String initialRoute = '/dashboard'})
      : super(SidebarState(activeItem: initialRoute));

  void changeActiveItem(String route) {
    if (state.activeItem != route) {
      emit(state.copyWith(activeItem: route));
    }
  }

  void changeHoverItem(String route) {
    emit(state.copyWith(hoverItem: route));
  }

  void menuOnTap(BuildContext context, String route) {
    if (!state.isActive(route)) {
      changeActiveItem(route);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      context.go(route);
    }
  }
}
