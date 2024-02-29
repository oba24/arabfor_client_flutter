import 'model.dart';

class AddRatingState {}

class LoadingAddRatingState extends AddRatingState {}

class FaildAddRatingState extends AddRatingState {
  String msg;
  int errType;
  FaildAddRatingState({required this.errType, required this.msg});
}

class DoneAddRatingState extends AddRatingState {
  String msg;
  AddRatingModel model;
  DoneAddRatingState(this.msg, this.model);
}
