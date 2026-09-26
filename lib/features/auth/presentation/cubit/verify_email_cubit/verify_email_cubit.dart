import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

import '../../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../domain/repos/verify_email_repo.dart';

part 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final VerifyEmailRepo _verifyEmailRepo;
  VerifyEmailCubit({required this._verifyEmailRepo}) : super(VerifyEmailState());

  Future<void> sendVerificationEmail() async{
   final result =  await _verifyEmailRepo.sendEmailVaerification();
  result.fold((error){
    emit(state.copyWith(status: VerifyEmailStatus.failure, message: error.message));
  }, (right){
    emit(state.copyWith(status: VerifyEmailStatus.sent,
        message:'A verification email has been sent. Please check your'
            ' inbox and verify your email.',
    ));
  });
  }

  Future<void> resendVerificationEmail() async{
    emit(state.copyWith(status: VerifyEmailStatus.resendLoading));
    final result =  await _verifyEmailRepo.sendEmailVaerification();
    result.fold((error){
      emit(state.copyWith(status: VerifyEmailStatus.failure, message: error.message));
    }, (right){
      emit(state.copyWith(status: VerifyEmailStatus.sent,
        message:'A verification email has been sent. Please check your'
            ' inbox and verify your email.',
      ));
    });
  }

  Future<void> setTimerForAutoRedirect(BuildContext context, VerifyEmailCubit controller)async {
    Timer.periodic(const Duration(seconds: 1), (timer) async{
     await FirebaseAuth.instance.currentUser?.reload();
     final user = FirebaseAuth.instance.currentUser;
     if(user?.emailVerified ?? false){
       timer.cancel();
       context.pushReplacementNamed(
         'success-screen',
         queryParameters: {
           'image': TImages.successfullyRegisterAnimation,
           'title': TTexts.yourAccountCreatedTitle,
           'subTitle': TTexts.yourAccountCreatedSubTitle,
         },
         extra: controller,
       );
     }
    });
  }

  Future<void> checkEmailVerificationStatus(BuildContext context, VerifyEmailCubit controller) async {
    emit(state.copyWith(status: VerifyEmailStatus.checkLoading));

    try {
      await FirebaseAuth.instance.currentUser?.reload(); // ✅ السطر المهم
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        emit(state.copyWith(status: VerifyEmailStatus.verified));
      } else {
        emit(state.copyWith(
          status: VerifyEmailStatus.failure,
          message: 'Email is not verified yet.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: VerifyEmailStatus.failure,
        message: 'حدث خطأ أثناء التحقق: ${e.toString()}',
      ));
    }
  }
}
