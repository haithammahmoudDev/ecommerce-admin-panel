import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/features/auth/domain/repos/profile_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../common/preferences/save_user_by_hive.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../order/domain/entities/user_entity.dart';
import '../../screens/login/login_screen.dart';


part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required ProfileRepo personalizationRepo})
      : _personalizationRepo = personalizationRepo,
        super(UserState());

  final ProfileRepo _personalizationRepo;

  Future<void> getUserData() async {
    final cachedUser = UserRepository().getUser();

    if (cachedUser != null) {
      if (!isClosed) {
        emit(state.copyWith(
          user: cachedUser,
          userDataStatus: UserDataStatus.loaded,
        ));
      }
    } else {
      if (!isClosed) {
        emit(state.copyWith(userDataStatus: UserDataStatus.loading));
      }
    }

    final result = await _personalizationRepo.getUserData();

    // ✅ فحص إضافي بعد الـ await، لأن الوقت اللي استغرقه الطلب
    // ممكن يكون كافي إن الـ Cubit يتقفل في الأثناء
    if (isClosed) return;

    result.fold(
          (error) {
        if (cachedUser == null) {
          if (!isClosed) {
            emit(state.copyWith(
              errorMessage: error.message,
              userDataStatus: UserDataStatus.error,
            ));
          }
        }
      },
          (freshUser) async {
        await UserRepository().saveUser(freshUser);
        if (!isClosed) {
          emit(state.copyWith(
            user: freshUser,
            userDataStatus: UserDataStatus.loaded,
          ));
        }
      },
    );
  }

  Future<void> updateUserData({required UserEntity user}) async {
    if (!isClosed) {
      emit(state.copyWith(userDataStatus: UserDataStatus.loading));
    }

    final result = await _personalizationRepo.updateUserData(user: user);

    if (isClosed) return;

    result.fold(
          (error) {
        if (!isClosed) {
          emit(state.copyWith(
            errorMessage: error.message,
            userDataStatus: UserDataStatus.error,
          ));
        }
      },
          (_) async {
        await UserRepository().saveUser(user);
        if (!isClosed) {
          emit(state.copyWith(
            user: user,
            userDataStatus: UserDataStatus.loaded,
          ));
        }
      },
    );
  }


  Future<void> pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (image == null) return;

    if (!isClosed) {
      emit(state.copyWith(userDataStatus: UserDataStatus.loading));
    }

    final result = await _personalizationRepo.uploadImagePic(file: File(image.path));

    if (isClosed) return;

    result.fold((error) {
      if (!isClosed) {
        emit(state.copyWith(userDataStatus: UserDataStatus.error, errorMessage: error.message));
      }
    }, (success) {
      if (!isClosed) {
        emit(state.copyWith(
          user: UserRepository().getUser()!.copyWith(
            profilePicture: success,
          ),
          userDataStatus: UserDataStatus.loaded,
        ));
      }
    });
  }


  Future<void> deleteAccount(BuildContext context) async {
    try {
      TFullScreenLoader.openLoadingDialog(
        'Processing...',
        TImages.docerAnimation,
        context,
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      final provider = currentUser?.providerData.isNotEmpty == true
          ? currentUser!.providerData.first.providerId
          : '';

      if (provider.isEmpty) {
        TFullScreenLoader.stopLoading(context);
        return;
      }

      if (provider == 'google.com') {
        await _personalizationRepo.deleteAccount();
        if (!context.mounted) return;

        TFullScreenLoader.stopLoading(context);
        context.goNamed('login');
      } else if (provider == 'password') {
        if (!context.mounted) return;

        TFullScreenLoader.stopLoading(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => BlocProvider.value(
        //       value: context.read<UserCubit>(),
        //       child: const ReAuthLoginForm(),
        //     ),
        //   ),
        // );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading(context);
      if (!isClosed) {
        emit(state.copyWith(
          errorMessage: e.toString(),
          userDataStatus: UserDataStatus.error,
        ));
      }
    }
  }

  Future<void> reAuthenticateEmailAndPasswordUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    TFullScreenLoader.openLoadingDialog(
      'Processing...',
      TImages.docerAnimation,
      context,
    );

    final result = await _personalizationRepo.reAuthenticateEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
          (error) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Error',
          context: context,
          message: error.message,
        );
      },
          (_) {
        TFullScreenLoader.stopLoading(context);
        context.goNamed('login');
      },
    );
  }
}