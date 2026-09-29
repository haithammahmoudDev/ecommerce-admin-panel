import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'sidebar_state.dart';

class SidebarCubit extends Cubit<SidebarState> {
  SidebarCubit({String initialRoute = '/dashboard'})
    : super(SidebarState(activeItem: initialRoute));

  void changeActiveItem(String route) {
    if (state.activeItem != route) {
      emit(state.copyWith(activeItem: route));
    }
  }

  Future<void> changeHoverItem(String route) async {
    emit(state.copyWith(hoverItem: route));
  }

  Future<void> menuOnTap(BuildContext context, String route) async {
    if (!state.isActive(route)) {
      changeActiveItem(route);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (route == '/logout') {
        await FirebaseAuth.instance.signOut();

        if (!context.mounted) return;

        context.go('/login');
        return;
      }

      if (!context.mounted) return;

      context.go(route);
    }
  }
}
