import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/core/models/firebase/task_model.dart';
import 'package:tasky/core/utils/app_helper.dart';
import 'package:tasky/features/details/data/firebase/firebase_details_actions.dart'
    show FirebaseDetailsActions;

part 'action_state.dart';

class DetailsActionCubit extends Cubit<DetailsActionState> {
  TaskModel targetModel;
  DetailsActionCubit(this.targetModel) : super(ActionDetailsInitial());

  int get currentDate =>
      targetModel.date ?? DateTime.now().millisecondsSinceEpoch;

  int getPriority() => targetModel.priority ?? 1;

  String getCurrentDate() => AppHelper.getCleanDate(currentDate);
  void updateDate(DateTime? date) {
    if (date == null) return;
    targetModel = targetModel.copyWith(date: date.millisecondsSinceEpoch);
    emit(ActionDetailsPickDateState());
  }

  void updatePriority(int priority) {
    targetModel = targetModel.copyWith(priority: priority);
    emit(ActionDetailsPriorityState());
  }

  void updateTitle(String name) {
    if (name.isEmpty) return;
    targetModel = targetModel.copyWith(name: name);
  }

  void updateDesc(String desc) {
    if (desc.isEmpty) return;
    targetModel = targetModel.copyWith(description: desc);
  }

  void setIsCompelete(bool value) {
    targetModel = targetModel.copyWith(isCompleted: value);
  }

  Future<void> onDelete() async {
    emit(ActionLoadingState());
    final result = await FirebaseDetailsActions.delTask(targetModel.id!);
    switch (result) {
      case FBResultSuccess<void>():
        emit(ActionDetailsDeleteSuccessState());
      case FBResultError<void>():
        emit(ActionDetailsDeleteFailureState(result.errorMessage));
    }
  }

  Future<void> onSave() async {
    emit(ActionLoadingState());
    final result = await FirebaseDetailsActions.editTask(targetModel);
    switch (result) {
      case FBResultSuccess<void>():
        emit(ActionDetailsSaveSuccessState());
      case FBResultError<void>():
        emit(ActionDetailsSaveFailureState(result.errorMessage));
    }
  }
}
