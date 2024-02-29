import '../../../models/addres_model.dart';

class UserAddresState {}

class LoadingUserAddresState extends UserAddresState {}

class FaildUserAddresState extends UserAddresState {
  String msg;
  int errType;
  int statusCode;
  FaildUserAddresState({required this.errType, required this.msg, required this.statusCode});
}

class DoneAddAddresState extends UserAddresState {
  AddressDatum single;
  String msg;
  DoneAddAddresState(this.msg, this.single);
}

class DoneGetAddresState extends UserAddresState {
  List<AddressDatum> data;
  String msg;
  DoneGetAddresState(this.msg, this.data);
}

class DoneIsDefaultState extends UserAddresState {
  String msg;
  DoneIsDefaultState(this.msg);
}

class DoneDeleteState extends UserAddresState {
  String msg;
  DoneDeleteState(this.msg);
}
