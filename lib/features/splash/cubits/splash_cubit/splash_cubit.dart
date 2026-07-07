import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/features/splash/data/firebase/splash_firebase_database.dart';
import 'package:tasky/features/splash/data/models/onboarding_model.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  late final bool isLoggedInBefore;
  SplashCubit() : super(SplashInitial()) {
    checkUserState();
  }

  void checkUserState() {
    if (FirebaseAuth.instance.currentUser != null) {
      emit(SplashLoggedInState());
    } else {
      emit(SplashNotLoggedInState());
    }
  }

  Future<void> getOnboardingData() async {
    final onboardingData = await SplashFirebaseDatabase.getOnboardingData();
    await Future.delayed(Duration(seconds: 1));
    switch (onboardingData) {
      case FBResultSuccess<List<OnboardingModel>>():
        emit(SplashOnBoardingSuccessState(onboardingData.data));
      case FBResultError<List<OnboardingModel>>():
        emit(SplashOnBoardingFailureState(onboardingData.errorMessage));
    }
  }
}
