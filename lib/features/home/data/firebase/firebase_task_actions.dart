import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/core/models/firebase/task_model.dart';

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
      final doc = getCollection.doc(taskModel.id);
      taskModel.id = doc.id;
      await doc.set(taskModel);
      return FBResultSuccess<TaskModel>(taskModel);
    } catch (e) {
      return FBResultError(e.toString());
    }
  }

  static ResultResponse<List<TaskModel>> getTasks([bool Function(TaskModel)? onFilter]) async {
    try {
      final result = await getCollection.get();
      var tasks = result.docs.map<TaskModel>((ele) => ele.data());
      if(onFilter != null){
        tasks = tasks.where(onFilter);
      }
      return FBResultSuccess(tasks.toList());
    } catch (e) {
      return FBResultError(e.toString());
    }
  }

  static ResultResponse<void> delTask(String id) async {
    try {
      final doc = getCollection.doc(id);
      await doc.delete();
      return FBResultSuccess(null);
    } catch (e) {
      return FBResultError(e.toString());
    }
  }

  static ResultResponse<void> editTask(TaskModel taskModel) async {
    try{
      await getCollection.doc(taskModel.id).update(TaskModel.toJson(taskModel));
      return FBResultSuccess(null);
    } catch (e) {
      return FBResultError(e.toString());
    }
  }
}
