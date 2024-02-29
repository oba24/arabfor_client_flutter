import 'model.dart';

class ProductDetailState {}

class LoadingProductDetailState extends ProductDetailState {}

class FaildProductDetailState extends ProductDetailState {
  String msg;
  int errType;
  int statusCode;
  FaildProductDetailState({required this.errType, required this.msg, required this.statusCode});
}

class DoneProductDetailState extends ProductDetailState {
  String msg;
  ProductDetailModel model;
  DoneProductDetailState(this.msg, this.model);
}
