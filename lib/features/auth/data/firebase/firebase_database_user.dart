import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class FirebaseDatabaseUser {
  static CollectionReference<UserModel> get getCollection => FirebaseFirestore
      .instance
      .collection(UserModel.collectionName)
      .withConverter<UserModel>(
        fromFirestore: (snapshot, options) =>
            UserModel.fromJson(snapshot.data()!),
        toFirestore: (userModel, options) => UserModel.toJson(userModel),
      );

  static ResultResponse<UserModel> registerUser(UserModel userModel) async {
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );
      userModel.id = result.user!.uid;
      
      await getCollection.doc(userModel.id).set(userModel);
      return FBResultSuccess(userModel);
    } catch (e) {
      return FBResultError(e.toString());
    }
  }

  static ResultResponse<UserModel> loginUser(UserModel userModel) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );
      userModel.id = result.user!.uid;
      return FBResultSuccess(userModel);
    } catch (e) {
      return FBResultError(e.toString());
    }
  }

  
}
