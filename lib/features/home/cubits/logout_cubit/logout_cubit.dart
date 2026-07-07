import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/features/auth/data/models/user_model.dart';
import 'package:tasky/features/home/data/firebase/firebase_user_actions.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoadingState());
    final result = await FirebaseUserActions.logoutUser();
    switch (result) {
      case FBResultSuccess<UserModel>():
        emit(LogoutSuccessState());
      case FBResultError<UserModel>():
        emit(LogoutFailureState(result.errorMessage));
    }
  }
}
