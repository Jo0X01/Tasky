import 'dart:convert';
import 'dart:typed_data';

import 'package:tasky/core/utils/app_helper.dart';

class OnboardingModel {
  static const String collectionName = 'OnBoardingScreen';
  static const String indicatorCollectionName = 'IndicatorData';

  String? title;
  String? desc;
  String? imageDataBase64String;

  OnboardingModel({this.title, this.desc, this.imageDataBase64String});

  OnboardingModel.fromJson(Map<String, dynamic> json)
    : this(
        title: json['title'],
        desc: json['desc'],
        imageDataBase64String: json['image'],
      );

  Map<String, dynamic> toJson() => {
      'title': title,
      'desc': desc,
      'image': imageDataBase64String
    };
  Uint8List? imageConvertFromBase64() {
    return imageDataBase64String == null ? null:base64Decode(AppHelper.cleanBase64(imageDataBase64String!));
  }
}