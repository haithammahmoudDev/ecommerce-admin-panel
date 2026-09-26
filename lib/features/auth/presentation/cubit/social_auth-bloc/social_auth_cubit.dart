import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../order/domain/entities/user_entity.dart';
import '../../../domain/repos/social_auth_repo.dart';
part 'social_auth_state.dart';

class SocialAuthCubit extends Cubit<SocialAuthState> {
  final SocialAuthRepo _socialAuthRepo;
  SocialAuthCubit({required this._socialAuthRepo}) : super(SocialAuthInitial());

  Future<void> signInWithGoogle() async{
    emit(SocialAuthLoading());
    final result = await _socialAuthRepo.signInWithGoogle();
    result.fold((failure){
      emit(SocialAuthFailure(errorMessage: failure.message));
    }, (success){
      emit(SocialAuthSuccess(user: success));
    });
  }
}
