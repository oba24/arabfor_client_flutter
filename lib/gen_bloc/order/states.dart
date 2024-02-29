import 'package:flutter/services.dart';

import '../../models/order_model.dart';

class OrderState {}

class LoadingOrderState extends OrderState {}

class FaildOrderState extends OrderState {
  String msg;
  int errType;
  int statusCode;
  FaildOrderState({required this.errType, required this.msg,required this.statusCode});
}

class DoneOrderState extends OrderState {
  List<OrderDatum> data;
  String msg;
  DoneOrderState(this.msg, this.data);
}

class DoneSingleOrderState extends OrderState {
  OrderDatum data;
  String msg;
  DoneSingleOrderState(this.msg, this.data);
}

class DoneChangStatusOrderState extends OrderState {
  OrderDatum data;
  String msg;
  DoneChangStatusOrderState(this.msg, this.data);
}
