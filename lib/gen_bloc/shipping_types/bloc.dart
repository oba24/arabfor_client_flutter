import '../../models/shipping_model.dart';
import '../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  ShippingBloc() : super(ShippingState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<ShippingState> mapEventToState(ShippingEvent event) async* {
    if (event is StartShippingEvent) {
      // show loader ........ ?

      yield LoadingShippingState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo();

      if (response.success) {
       

        // await CustomProgressDialog.hidePr();
        yield DoneShippingState(response.msg,  List<ShippingModel>.from(
            (response.response!.data["data"] ?? [])
                .map((x) => ShippingModel.fromJson(x))));
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildShippingState(
          msg: response.msg,
          errType: response.errType ?? 0,
        );
      }
    }
  }

  Future<CustomResponse> repo() async {
    CustomResponse response = await serverGate.getFromServer(
      url: "shipping_type",
    );
    return response;
  }
}
