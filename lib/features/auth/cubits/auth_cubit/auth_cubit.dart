import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/features/auth/data/firebase/firebase_database_user.dart';
import 'package:tasky/features/auth/data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoginLoadingState());
    final result = await FirebaseDatabaseUser.loginUser(
      UserModel(email: email, password: password),
    );
    switch (result) {
      case FBResultSuccess<UserModel>():
        emit(AuthLoginSuccessState(result.data));
      case FBResultError<UserModel>():
        emit(AuthLoginFailureState(result.errorMessage));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(AuthRegisterLoadingState());
    final result = await FirebaseDatabaseUser.registerUser(
      UserModel(email: email, password: password, userName: username),
    );
    switch (result) {
      case FBResultSuccess<UserModel>():
        emit(AuthRegisterSuccessState(result.data));
      case FBResultError<UserModel>():
        emit(AuthRegisterFailureState(result.errorMessage));
    }
  }
}
