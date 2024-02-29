import 'home_model.dart';

class HomeState {}

class LoadingHomeState extends HomeState {}

class FaildHomeState extends HomeState {
  String msg;
  int errType;
  int statusCode;
  FaildHomeState({required this.errType, required this.msg, required this.statusCode});
}

class DoneHomeState extends HomeState {
  String msg;
  HomeModel model;
  DoneHomeState(this.msg, this.model);
}
