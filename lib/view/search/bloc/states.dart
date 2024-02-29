import 'model.dart';

class SearchState {}

class LoadingSearchState extends SearchState {}

class FaildSearchState extends SearchState {
  String msg;
  int errType;
  int statusCode;
  FaildSearchState({required this.errType, required this.msg,required this.statusCode});
}

class DoneSearchState extends SearchState {
  String msg;
  SearchModel model;
  DoneSearchState(this.msg, this.model);
}
