import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tasky/bloc_app_observer.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/features/auth/cubits/auth_cubit/auth_cubit.dart';
import 'package:tasky/features/auth/view/login_screen.dart';
import 'package:tasky/features/auth/view/register_screen.dart';
import 'package:tasky/features/details/view/details_screen.dart';
import 'package:tasky/features/home/view/home_screen.dart';
import 'package:tasky/features/splash/cubits/splash_cubit/splash_cubit.dart';
import 'package:tasky/features/splash/view/onboarding_screen.dart';
import 'package:tasky/features/splash/view/splash_screen.dart';
import 'package:tasky/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Bloc.observer = BlocAppObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => SplashCubit()),
      ],
      child: const TaskyApp(),
    ),
  );
}

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      builder: EasyLoading.init(),
      initialRoute: AppRoutes.splashScreen,
      routes: {
        AppRoutes.onBoardingScreen: (context) => OnboardingScreen(),
        AppRoutes.splashScreen: (context) => SplashScreen(),
        AppRoutes.loginScreen: (context) => LoginScreen(),
        AppRoutes.registerScreen: (context) => RegisterScreen(),
        AppRoutes.homeScreen: (context) => HomeScreen(),
        AppRoutes.detailScreen: (context) => DetailsScreen(),
      },
    );
  }
}
