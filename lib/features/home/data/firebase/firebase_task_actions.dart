import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/features/home/data/model/task_model.dart';

abstract class FirebaseTaskActions {
  static CollectionReference<TaskModel> get getCollection => FirebaseFirestore
      .instance
      .collection(FirebaseCollectionConstant.userModelCollectionName)
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection(FirebaseCollectionConstant.taskModelCollectionName)
      .withConverter<TaskModel>(
        fromFirestore: (snapshot, options) =>
            TaskModel.fromJson(snapshot.data()!),
        toFirestore: (userModel, options) => TaskModel.toJson(userModel),
      );
  static ResultResponse<TaskModel> addTask(TaskModel taskModel) async {
    try {
      final doc = getCollection.doc();
      taskModel.id = doc.id;
      await doc.set(taskModel);
      return FBResultSuccess<TaskModel>(taskModel);
    } catch (e) {
      return FBResultError(e.toString());
    }
  }

  static ResultResponse<List<TaskModel>> getTasks() async {
    try{
      final result = await getCollection.get();
      final tasks = result.docs.map<TaskModel>((ele) => ele.data()).toList();
      return FBResultSuccess(tasks);
    }catch(e){
      return FBResultError(e.toString());
    }
  }

}
