import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

abstract class AppDialog {
  static void showLoading(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: SpinKitRotatingCircle(color: Color.fromARGB(255, 167, 11, 11), size: 50.0),
          );
        },
      );
    });
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
      title: Text(msg),
      alignment: Alignment.bottomCenter,
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
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }

  static void hide(BuildContext context) {
    // CustomLoading.dismiss(context);
    Navigator.pop(context);
  }
}
