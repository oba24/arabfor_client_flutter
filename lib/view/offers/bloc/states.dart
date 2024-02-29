import '../../../models/product_data.dart';

class OffersState {}

class LoadingOffersState extends OffersState {}

class FaildOffersState extends OffersState {
  String msg;
  int errType;
  int statusCode;
  FaildOffersState({required this.errType, required this.msg,required this.statusCode});
}

class DoneOffersState extends OffersState {
  String msg;
  List<ProductData> data;

  DoneOffersState(this.msg, this.data);
}
