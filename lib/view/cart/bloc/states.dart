import 'model.dart';

class CartState {}

class LoadingCartState extends CartState {
  final String type;

  LoadingCartState({required this.type});
}

class FaildCartState extends CartState {
  String msg;
  int errType;
  int statusCode;
  FaildCartState({required this.errType, required this.msg, required this.statusCode});
}

class DoneGetCartState extends CartState {
  String msg;
  CartModel data;
  DoneGetCartState(this.msg, this.data);
}

class DoneControllerCartState extends CartState {
  String msg;
  CartModel data;
  DoneControllerCartState(this.msg, this.data);
}

class DoneApplyCouponState extends CartState {
  String msg;
  CartModel data;
  DoneApplyCouponState(this.msg, this.data);
}
