import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toastification/toastification.dart';

abstract class AppDialog {
  static void areYouSureDialog(
    BuildContext context,
    String msg,
    void Function() btnOkOnPress,
  ) {
    AwesomeDialog(
      context: context,
      title: "Are You Sure ?",
      animType: AnimType.scale,
      keyboardAware: false,
      dismissOnTouchOutside: false,
      dialogType: DialogType.question,
      reverseBtnOrder: true,
      desc: msg,
      btnCancelColor: Color(0xff5F33E1),
      btnCancelOnPress: () {},
      btnOkOnPress: btnOkOnPress,
    ).show();
  }

  static void showLoading(BuildContext context) {
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.chasingDots;
    EasyLoading.instance.indicatorColor = Color(0xff5F33E1);
    EasyLoading.instance.maskColor = Color(0xff5F33E1);
    EasyLoading.instance.backgroundColor = Colors.black;
    EasyLoading.instance.indicatorColor = Color(0xff5F33E1);
    EasyLoading.instance.textColor = Colors.white;
    EasyLoading.instance.dismissOnTap = false;
    EasyLoading.instance.contentPadding = EdgeInsets.all(25);
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(status: 'Loading...');
  }

  static void showErrorDialog(BuildContext context, String msg) {
    AwesomeDialog(
      context: context,
      title: "Error",
      animType: AnimType.scale,
      // headerAnimationLoop: false,
      keyboardAware: false,
      dismissOnTouchOutside: false,
      dialogType: DialogType.error,
      reverseBtnOrder: true,
      desc: msg,
      btnCancelText: "Close",
      btnCancelColor: Color(0xff5F33E1),
      btnCancelOnPress: () {},
    ).show();
  }

  static void showSuccessDialog(
    BuildContext context,
    String msg, {
    void Function()? onDismiss,
  }) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.success,
      style: ToastificationStyle.simple,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(
        msg,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.check),
      showIcon: true, // show or hide the icon
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      borderSide: BorderSide(color: Color(0xff5F33E1)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  static void hide(BuildContext context) {
    EasyLoading.dismiss();
  }
}
