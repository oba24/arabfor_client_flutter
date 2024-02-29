import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is StartRegisterEvent) {
      // show loader ........ ?

      yield LoadingRegisterState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(event.toJson());

      if (response.success) {
        // RegisterModel _model = RegisterModel.fromJson(response.response.data);

        // await CustomProgressDialog.hidePr();
        yield DoneRegisterState(response.msg);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildRegisterState(
          msg: response.msg,
          errType: response.errType!,
        );
      }
    }
  }

  Future<CustomResponse> repo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "client-register", body: body);
    return response;
  }
}
