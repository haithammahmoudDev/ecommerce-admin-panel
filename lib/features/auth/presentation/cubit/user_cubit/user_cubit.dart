import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/common/local_storage/local_storage_service.dart';
import 'package:ecommerce_admin_pannal/features/auth/domain/repos/profile_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../media/data/models/image_model.dart';
import '../../../../media/presentation/controller/media_cubit/media_cubit.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/entities/user_entity.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required ProfileRepo personalizationRepo})
      : _personalizationRepo = personalizationRepo,
        super(UserState()){
    getUserData();
  }

  final ProfileRepo _personalizationRepo;

  Future<void> getUserData() async {
    final UserModel? cachedUser = LocalStorageService.userRepo.getData();

    if (cachedUser != null) {
      if (!isClosed) {
        emit(state.copyWith(
          user: cachedUser.toEntity(),
          userDataStatus: UserDataStatus.loaded,
        ));
      }
    } else {
      if (!isClosed) {
        emit(state.copyWith(userDataStatus: UserDataStatus.loading));
      }
    }

    final result = await _personalizationRepo.getUserData();
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
            await LocalStorageService.userRepo.saveData(UserModel.fromEntity(freshUser));
        if (!isClosed) {
          emit(state.copyWith(
            user: freshUser,
            userDataStatus: UserDataStatus.loaded,
          ));
        }
      },
    );
  }

  Future<void> updateUserData(BuildContext context, {required UserEntity user}) async {
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
          TLoaders.errorSnackBar(title: 'Updated Error', context: context,
              message: 'Failed to update Your Profile');
        }
      },
          (_) async {
            await LocalStorageService.userRepo.saveData(UserModel.fromEntity(user));
            TLoaders.successSnackBar(title: 'Updated', context: context,
                message: 'Your Profile updated successfully!');
        if (!isClosed) {
          emit(state.copyWith(
            user: user,
            userDataStatus: UserDataStatus.loaded,
          ));
        }
      },
    );
  }


  Future<void> pickImage(BuildContext context) async {
    // 1. فتح نظام الميديا الخاص بالتطبيق لاختيار الصورة
    final MediaCubit mediaCubit = context.read<MediaCubit>();
    List<ImageModel>? selectedImages = await mediaCubit.selectImagesFromMedia(context: context);

    if (isClosed) return;
    if (selectedImages == null || selectedImages.isEmpty) return;

    if (!isClosed) {
      emit(state.copyWith(userDataStatus: UserDataStatus.loading));
    }

     ImageModel selectedImage = selectedImages.first;

     final result = await _personalizationRepo.updateProfilePictureUrl(imageUrl: selectedImage.url);

    if (isClosed) return;

    result.fold(
          (error) {
        if (!isClosed) {
          emit(state.copyWith(
            userDataStatus: UserDataStatus.error,
            errorMessage: error.message,
          ));
        }
      },
          (successUrl) {
        if (!isClosed) {
          emit(state.copyWith(
            user: LocalStorageService.userRepo.getData()!.copyWith(
              profilePicture: successUrl,
              updatedAt: DateTime.now(),
            ).toEntity(),
            userDataStatus: UserDataStatus.loaded,
          ));
        }
      },
    );
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