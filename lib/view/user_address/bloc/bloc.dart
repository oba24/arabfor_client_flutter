import 'package:saudimarchclient/view/user_address/bloc/model.dart';

import '../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAddresBloc extends Bloc<UserAddresEvent, UserAddresState> {
  UserAddresBloc() : super(UserAddresState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<UserAddresState> mapEventToState(UserAddresEvent event) async* {
    if (event is StartAddAddresEvent) {
      yield LoadingUserAddresState();
      CustomResponse response = await _addAddressRepo(await event.body);
      if (response.success) {
        AddressModel _model = AddressModel.fromJson(response.response?.data, isSingle: true);
        yield DoneAddAddresState(response.msg, _model.single);
      } else {
        yield FaildUserAddresState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
    if (event is StartGetAddressesEvent) {
      yield LoadingUserAddresState();
      CustomResponse response = await _getAddress();
      if (response.success) {
        AddressModel _model = AddressModel.fromJson(response.response?.data);
        yield DoneGetAddresState(response.msg, _model.data);
      } else {
        yield FaildUserAddresState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
    if (event is StartIsDefaultEvent) {
      yield LoadingUserAddresState();
      CustomResponse response = await _isDefaultAddress(event.id);
      if (response.success) {
        yield DoneIsDefaultState(response.msg);
      } else {
        yield FaildUserAddresState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
    if (event is StartDeleteEvent) {
      yield LoadingUserAddresState();
      CustomResponse response = await _deleteAddress(event.id);
      if (response.success) {
        yield DoneDeleteState(response.msg);
      } else {
        yield FaildUserAddresState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> _addAddressRepo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "client/address", body: body);
    return response;
  }

  Future<CustomResponse> _getAddress() async {
    CustomResponse response = await serverGate.getFromServer(url: "client/address");
    return response;
  }

  Future<CustomResponse> _isDefaultAddress(int id) async {
    CustomResponse response = await serverGate.sendToServer(url: "client/address/is_default/$id");
    return response;
  }

  Future<CustomResponse> _deleteAddress(int id) async {
    CustomResponse response = await serverGate.deleteFromServer(url: "client/address/$id");
    return response;
  }
}
