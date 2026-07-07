part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}
final class SplashLoggedInState extends SplashState {}
final class SplashNotLoggedInState extends SplashState {}
final class SplashLoadingState extends SplashState {}
final class SplashOnBoardingSuccessState extends SplashState {
  final List<OnboardingModel> data;
  SplashOnBoardingSuccessState(this.data);
}
final class SplashOnBoardingFailureState extends SplashState {
  final String msg;
  SplashOnBoardingFailureState(this.msg);
}