part of 'home_item_cubit.dart';

@immutable
sealed class HomeItemState {}

final class HomeItemInitial extends HomeItemState {}

final class HomeItemLoadingState extends HomeItemState {}

final class HomeItemSuccessState extends HomeItemState {
  final List<TaskModel> data;
  HomeItemSuccessState(this.data);
}

final class HomeItemFailureState extends HomeItemState {
  final String msg;
  HomeItemFailureState(this.msg);
}
