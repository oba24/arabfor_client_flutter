import '../../../../helper/user_data.dart';
import '../../../../models/user_model.dart';
import '../../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveCodeBloc extends Bloc<ActiveCodeEvent, ActiveCodeState> {
  ActiveCodeBloc() : super(ActiveCodeState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<ActiveCodeState> mapEventToState(ActiveCodeEvent event) async* {
    if (event is StartActiveCodeEvent) {
      // show loader ........ ?

      yield LoadingActiveCodeState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(await event.toJson(), event.type);

      if (response.success) {
        // ActiveCodeModel _model = ActiveCodeModel.fromJson(response.response.data);
        UserHelper.setUserData(UserModel.fromJson(response.response?.data["data"]));
        // await CustomProgressDialog.hidePr();
        yield DoneActiveCodeState(response.msg);
      } else {
        // await CustomProgressDialog.hidePr();

        yield FaildActiveCodeState(
          msg: response.msg,
          errType: response.errType ?? 0,
        );
      }
    }
  }

  Future<CustomResponse> repo(Map<String, dynamic> body, TYPE type) async {
    CustomResponse response = await serverGate.sendToServer(url: type == TYPE.register ? "verify" : "check_code", body: body);
    return response;
  }
}
