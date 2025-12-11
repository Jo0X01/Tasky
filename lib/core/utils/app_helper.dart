
abstract class AppHelper {

  static String cleanBase64(String base64String) {  
    return base64String.replaceAll(
      RegExp(r'data:image/[^;]+;base64,'),
      ''
    );
  }
  static String getCleanDate(int? millisecondsSinceEpoch){
    final date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch);
    return "${date.day} / ${date.month} / ${date.year}";
  }

}