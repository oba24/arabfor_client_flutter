import '../../models/shipping_model.dart';

class ShippingState {}

class LoadingShippingState extends ShippingState {}

class FaildShippingState extends ShippingState {
  String msg;
  int errType;
  FaildShippingState({required this.errType, required this.msg});
}

class DoneShippingState extends ShippingState {
  String msg;
  List<ShippingModel> shipping;
  DoneShippingState(this.msg, this.shipping);
}
