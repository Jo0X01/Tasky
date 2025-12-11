import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/features/splash/data/firebase/splash_firebase_database.dart';
import 'package:tasky/features/splash/data/models/onboarding_model.dart';
import 'package:tasky/features/splash/view/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = AppRoutes.splashScreen;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (!await navigateIfLoggedIn()) {
          getDataThenNavigate();
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5F33E1),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInLeft(
              duration: Duration(milliseconds: 900),
              animate: true,
              child: Image.asset(AssetConstant.taskIcon),
            ),
            BounceInDown(
              from: 50,
              animate: true,
              delay: Duration(milliseconds: 900),
              duration: Duration(milliseconds: 600),
              child: Image.asset(AssetConstant.yIcon),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> navigateIfLoggedIn() async {
    final isLoggedInBefore = FirebaseAuth.instance.currentUser != null;
    if (isLoggedInBefore) {
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
    }
    return isLoggedInBefore;
  }

  void getDataThenNavigate() async {
    final onboardingData = await SplashFirebaseDatabase.getOnboardingData();
    await Future.delayed(Duration(seconds: 1));
    switch (onboardingData) {
      case FBResultSuccess<List<OnboardingModel>>():
        Navigator.of(context).pushReplacementNamed(
          OnboardingScreen.routeName,
          arguments: onboardingData.data,
        );
      case FBResultError<List<OnboardingModel>>():
        Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen);
    }
  }
}
