import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> changeHoverItem(String route) async{
    emit(state.copyWith(hoverItem: route));
  }

  Future<void> menuOnTap(BuildContext context, String route) async {
    if (!state.isActive(route)) {
      changeActiveItem(route);

      // إغلاق القائمة الجانبية (Drawer) إن وجدت
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (route == '/logout') {
        await FirebaseAuth.instance.signOut();

        // مهم جداً: التحقق أن الـ Widget ما زالت موجودة في الشجرة بعد الـ await
        if (!context.mounted) return;

        context.go('/login');
        return;
      }

      // تحقق إضافي للاحتياط
      if (!context.mounted) return;

      context.go(route);
    }
  }
}
