class CreateOrderState {}

class LoadingCreateOrderState extends CreateOrderState {}

class FaildCreateOrderState extends CreateOrderState {
  String msg;
  int errType;
  FaildCreateOrderState({required this.errType, required this.msg});
}

class DoneCreateOrderState extends CreateOrderState {
  String msg;
  int orderId;
  DoneCreateOrderState(this.msg, this.orderId);
}
