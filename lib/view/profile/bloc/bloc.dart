import '../../../../repo/server_gate.dart';
import '../../../helper/user_data.dart';
import '../../../models/user_model.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc() : super(UpdateProfileState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<UpdateProfileState> mapEventToState(UpdateProfileEvent event) async* {
    if (event is StartUpdateProfileEvent) {
      yield LoadingUpdateProfileState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await updateProfileRepo(event.body);
      if (response.success) {
        UserModel _model = UserModel.fromJson(response.response?.data["data"]);
        _model.token = UserHelper.userDatum.token;
        UserHelper.setUserData(_model);
        // await CustomProgressDialog.hidePr();
        yield DoneUpdateProfileState(response.msg);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildUpdateProfileState(
            msg: response.msg, errType: response.errType ?? 0);
      }
    }
    if (event is StartEditPasswordEvent) {
      yield LoadingUpdateProfileState();
      CustomResponse response = await updatePasswordRepo(event.body);
      if (response.success) {
        yield DoneEditPasswordState(response.msg);
      } else {
        yield FaildUpdateProfileState(
            msg: response.msg, errType: response.errType ?? 0);
      }
    }
  }

  Future<CustomResponse> updateProfileRepo(Map<String, dynamic> body) async {
    CustomResponse response =
        await serverGate.sendToServer(url: "client/profile", body: body);
    return response;
  }

  Future<CustomResponse> updatePasswordRepo(Map<String, dynamic> body) async {
    CustomResponse response =
        await serverGate.sendToServer(url: "edit_password", body: body);
    return response;
  }
}
