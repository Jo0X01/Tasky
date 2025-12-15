abstract class AppRoutes {
  static const String loginScreen = "/LoginScreen";
  static const String registerScreen = "/RegisterScreen";
  static const String splashScreen = "/SplashScreen";
  static const String onBoardingScreen = "/OnBoardingScreen";
  static const String homeScreen = "/HomeScreen";
  static const String detailScreen = "/DetailScreen";
}

abstract class AssetConstant {
  static const String taskIcon = "assets/icons/task-icon.png"; 
  static const String logoutIcon = "assets/icons/logout-icon.png"; 
  static const String sendIcon = "assets/icons/send-icon.png"; 
  static const String flagIcon = "assets/icons/flag-icon.png"; 
  static const String timerIcon = "assets/icons/timer-icon.png"; 
  static const String exitIcon = "assets/icons/exit-icon.png"; 
  static const String trashIcon = "assets/icons/trash-icon.png"; 
  static const String searchIcon = "assets/icons/search-icon.png"; 
  static const String yIcon = "assets/icons/y-icon.png";
  static const String logoImage = "assets/images/logo-image.png";
  static const String homeImage = "assets/images/home-image.png"; 
}

abstract class FirebaseCollectionConstant {
  static const String userModelCollectionName = "Users";
  static const String taskModelCollectionName = "Tasks";
}

abstract class FirebaseAppConstantAssetsFirestore {
  static const String collectionName = "AppConstantContent";
}