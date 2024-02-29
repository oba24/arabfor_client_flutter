import 'model.dart';

class StoreDetailState {}

class LoadingStoreDetailState extends StoreDetailState {}

class FaildStoreDetailState extends StoreDetailState {
  String msg;
  int errType;
  int statusCode;
  FaildStoreDetailState({required this.errType, required this.msg, required this.statusCode});
}

class DoneStoreDetailState extends StoreDetailState {
  String msg;
  StoreDetailModel model;
  DoneStoreDetailState(this.msg, this.model);
}
