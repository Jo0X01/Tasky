abstract class AppRoutes {
  static const String loginScreen = "/login_screen";
  static const String registerScreen = "/register_screen";
  static const String splashScreen = "/splash_screen";
  static const String onBoardingScreen = "/onboarding_screen";
  static const String homeScreen = "/home_screen";

}

abstract class AssetConstant {
  static const String taskIcon = "assets/icons/task-icon.png"; 
  static const String logoutIcon = "assets/icons/logout-icon.png"; 
  static const String sendIcon = "assets/icons/send-icon.png"; 
  static const String flagIcon = "assets/icons/flag-icon.png"; 
  static const String timerIcon = "assets/icons/timer-icon.png"; 
  static const String yIcon = "assets/icons/y-icon.png";
  static const String logoImage = "assets/images/logo-image.png";
  static const String homeImage = "assets/images/home-image.png"; 
}


abstract class FirebaseAppConstantAssetsFirestore {
  static const String collectionName = "AppConstantContent";
}