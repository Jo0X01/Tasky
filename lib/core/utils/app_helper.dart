
abstract class AppHelper {

  static String cleanBase64(String base64String) {  
    return base64String.replaceAll(
      RegExp(r'data:image/[^;]+;base64,'),
      ''
    );
  }

}