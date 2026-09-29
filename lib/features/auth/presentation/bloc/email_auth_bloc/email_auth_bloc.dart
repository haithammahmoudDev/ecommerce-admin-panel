import 'package:ecommerce_admin_pannal/features/settings/domain/entities/settings_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../settings/domain/repos/settings_repo.dart';
import '../../../domain/repos/email_auth_repo.dart';
part 'email_auth_event.dart';
part 'email_auth_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final EmailAuthRepo _emailAuthRepo;
  final SettingsRepo _settingsRepo;
  EmailAuthBloc({required this._emailAuthRepo,required this._settingsRepo}) : super(EmailAuthInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
  }
   Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(EmailAuthLoading());
    final result = await _emailAuthRepo.login(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) {
        emit(EmailAuthFailure(errorMessage: failure.message));
      },
      (success) {
        if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
          emit(EmailAuthSuccess());
        } else {
          emit(EmailNotVerified());
        }
      },
    );
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(EmailAuthLoading());
    final result = await _emailAuthRepo.signUp(
      userName: event.userName,
      email: event.email,
      password: event.password,
      phoneNumber: event.phoneNumber,
    );
    result.fold(
      (failure) {
        emit(EmailAuthFailure(errorMessage: failure.message));
      },
      (success) {
        emit(EmailAuthSuccess());
        _settingsRepo.registerSettings(SettingsEntity(
          appLogo: "assets/images/profile/89a8d3e7-5666-4676-a7b2-8244ced04447.png",
          appName: 'App Store',
          taxRate: 0,
          shippingCost: 0,
        ));
      },
    );
  }
}
