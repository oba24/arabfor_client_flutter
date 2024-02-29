class WalletState {}

class LoadingWalletState extends WalletState {}

class FaildWalletState extends WalletState {
  String msg;
  int errType;
  int statusCode;
  FaildWalletState({required this.errType, required this.msg, required this.statusCode});
}

class DoneWalletState extends WalletState {
  String msg;
  num wallet;
  DoneWalletState(this.msg, this.wallet);
}

class DoneRefundState extends WalletState {
  String msg;
  DoneRefundState(this.msg);
}
