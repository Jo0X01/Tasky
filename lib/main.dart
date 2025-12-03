
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/features/splash/view/onboarding_screen.dart';
import 'package:tasky/features/splash/view/splash_screen.dart';
import 'package:tasky/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(TaskyApp());
}


class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,

      initialRoute: AppRoutes.splashScreen,
      routes: {
        AppRoutes.onBoardingScreen: (context) => OnboardingScreen(),
        AppRoutes.splashScreen: (context) => SplashScreen(),
      },
    );
  }
}