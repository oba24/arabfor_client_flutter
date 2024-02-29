import '../../../repo/server_gate.dart';
import 'event.dart';
import 'state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  CreateOrderBloc() : super(CreateOrderState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<CreateOrderState> mapEventToState(CreateOrderEvent event) async* {
    if (event is StartCreateOrderEvent) {
      yield LoadingCreateOrderState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(event.body);
      if (response.success) {
        // CreateOrderModel _model = CreateOrderModel.fromJson(response.response.data);
        // await CustomProgressDialog.hidePr();
        yield DoneCreateOrderState(response.msg, (response.response?.data["data"] ?? {})["order_id"] ?? 0);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildCreateOrderState(msg: response.msg, errType: response.errType ?? 0);
      }
    }
  }

  Future<CustomResponse> repo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "client/client_order", body: body);
    return response;
  }
}
