

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/features/auth/data/models/user_model.dart';

abstract class FirebaseUserActions {
  static ResultResponse<UserModel> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      return FBResultSuccess(UserModel());
    } catch (e) {
      return FBResultError(e.toString());
    }
  }
}