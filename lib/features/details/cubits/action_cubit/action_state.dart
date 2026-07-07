part of 'action_cubit.dart';

sealed class DetailsActionState {}

final class DetailsNoDataProvided extends DetailsActionState {}

final class ActionDetailsInitial extends DetailsActionState {}

final class ActionLoadingState extends DetailsActionState {}

final class ActionDetailsSaveSuccessState extends DetailsActionState {}

final class ActionDetailsSaveFailureState extends DetailsActionState {
  final String msg;
  ActionDetailsSaveFailureState(this.msg);
}

final class ActionDetailsDeleteSuccessState extends DetailsActionState {}

final class ActionDetailsDeleteFailureState extends DetailsActionState {
  final String msg;
  ActionDetailsDeleteFailureState(this.msg);
}


final class ActionDetailsPickDateState extends DetailsActionState {}
final class ActionDetailsPriorityState extends DetailsActionState {}