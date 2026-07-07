import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/core/models/firebase/task_model.dart';
import 'package:tasky/features/home/data/firebase/firebase_task_actions.dart';

part 'home_item_state.dart';

class HomeItemCubit extends Cubit<HomeItemState> {
  HomeItemCubit() : super(HomeItemInitial());
  List<TaskModel> tasks = [];
  Set<int> filters = {0, 1};

  Future<void> addTask(TaskModel task) async {
    emit(HomeItemLoadingState());
    final result = await FirebaseTaskActions.addTask(task);
    switch(result){
      case FBResultSuccess<TaskModel>():
        getAllTasks();
      case FBResultError<TaskModel>():
        emit(HomeItemFailureState(result.errorMessage));
    }
  }

  bool isFiltered(int id) => filters.contains(id);
  void setFilter(int id, bool select) {
    select ? filters.add(id) : filters.remove(id);
    getAllTasks();
  }

  void onSearch(String? value) {
    emit(HomeItemLoadingState());
    final filteredTasks = tasks
        .where((m) => _filterModel(m, value!.toLowerCase()))
        .toList();
    emit(HomeItemSuccessState(filteredTasks));
  }

  Future<void> getAllTasks() async {
    emit(HomeItemLoadingState());
    final result = await FirebaseTaskActions.getTasks(_filterModel);
    switch (result) {
      case FBResultSuccess<List<TaskModel>>():
        tasks = result.data;
        emit(HomeItemSuccessState(result.data));
      case FBResultError<List<TaskModel>>():
        emit(HomeItemFailureState(result.errorMessage));
    }
  }

  bool _filterModel(TaskModel model, [String query = ""]) {
    final name = model.name?.toLowerCase();
    final desc = model.description?.toLowerCase();
    if (name == null || desc == null) return false;
    final isCompletedFilter = filters.contains(0);
    final isNotCompletedFilter = filters.contains(1);
    final bool isCompleted = model.isCompleted ?? false;
    if (!isCompletedFilter && !isNotCompletedFilter) {
      return false;
    }
    if (query.isNotEmpty && !(name.contains(query) || desc.contains(query))) {
      return false;
    }
    if (isCompletedFilter && isNotCompletedFilter) {
      return true;
    }
    if (isCompletedFilter && !isCompleted) return false;
    if (isCompletedFilter && isCompleted) return false;
    return true;
  }
}
