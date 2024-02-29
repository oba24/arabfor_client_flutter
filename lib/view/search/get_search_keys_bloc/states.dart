import 'model.dart';

class SearchKeysState {}

class LoadingSearchKeysState extends SearchKeysState {}

class FaildSearchKeysState extends SearchKeysState {
  String msg;
  int errType;
  FaildSearchKeysState({required this.errType, required this.msg});
}

class DoneSearchKeysState extends SearchKeysState {
  String msg;
  SearchKeysModel model;
  DoneSearchKeysState(this.msg, this.model);
}
