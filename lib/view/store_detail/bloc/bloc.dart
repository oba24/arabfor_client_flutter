import 'package:saudimarchclient/repo/server_gate.dart';

import 'model.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreDetailBloc extends Bloc<StoreDetailEvent, StoreDetailState> {
  StoreDetailBloc() : super(StoreDetailState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<StoreDetailState> mapEventToState(StoreDetailEvent event) async* {
    if (event is StartStoreDetailEvent) {
      // show loader ........ ?

      yield LoadingStoreDetailState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(event.id);

      if (response.success) {
        StoreDetailModel _model = StoreDetailModel.fromJson(
          response.response?.data,
        );

        // await CustomProgressDialog.hidePr();
        yield DoneStoreDetailState(response.msg, _model);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildStoreDetailState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> repo(int id) async {
    CustomResponse response = await serverGate.getFromServer(
      url: "seller_profile/$id",
    );
    return response;
  }
}
