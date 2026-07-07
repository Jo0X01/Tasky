import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/utils/app_dialog.dart';
import 'package:tasky/features/splash/cubits/splash_cubit/splash_cubit.dart';
import 'package:tasky/features/splash/view/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const String routeName = AppRoutes.splashScreen;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) async {
        if (state is SplashLoggedInState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
        } else if (state is SplashNotLoggedInState) {
          BlocProvider.of<SplashCubit>(context).getOnboardingData();
        } else if (state is SplashOnBoardingSuccessState) {
          Navigator.of(context).pushReplacementNamed(
            OnboardingScreen.routeName,
            arguments: state.data,
          );
        } else if (state is SplashOnBoardingFailureState) {
          AppDialog.showErrorDialog(
            context,
            "Can`t Reach Server",
            cancelText: "Retry",
            onDismiss: BlocProvider.of<SplashCubit>(context).checkUserState,
          );
        }
      },
      child: Scaffold(
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
                onFinish: (_) =>
                    BlocProvider.of<SplashCubit>(context).checkUserState(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
