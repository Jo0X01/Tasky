part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthLoginLoadingState extends AuthState {}

final class AuthLoginFailureState extends AuthState {
  final String msg;
  AuthLoginFailureState(this.msg);
}

final class AuthLoginSuccessState extends AuthState {
  final UserModel model;
  AuthLoginSuccessState(this.model);
}

final class AuthRegisterLoadingState extends AuthState {}

final class AuthRegisterFailureState extends AuthState {
  final String msg;
  AuthRegisterFailureState(this.msg);
}

final class AuthRegisterSuccessState extends AuthState {
  final UserModel model;
  AuthRegisterSuccessState(this.model);
}
