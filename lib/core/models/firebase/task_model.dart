import 'package:tasky/core/constant/app_constants.dart';

class TaskModel {
  static const String collectionName =
      FirebaseCollectionConstant.taskModelCollectionName;

  TaskModel({
    this.id,
    this.name,
    this.description,
    this.priority,
    this.date,
    this.isCompleted,
  });

  String? id;
  String? name;
  String? description;
  int? priority;
  int? date;
  bool? isCompleted;

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    priority = json['priority'];
    date = json['date'];
    isCompleted = json['isCompleted'];
  }
  static Map<String, dynamic> toJson(TaskModel taskModel) {
    return {
      'id': taskModel.id,
      'name': taskModel.name,
      'description': taskModel.description,
      'priority': taskModel.priority,
      'date': taskModel.date,
      'isCompleted': taskModel.isCompleted,
    };
  }

  TaskModel copyWith({
    String? id,
    String? name,
    String? description,
    int? priority,
    int? date,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
