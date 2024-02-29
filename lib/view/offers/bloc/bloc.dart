import '../../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  OffersBloc() : super(OffersState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<OffersState> mapEventToState(OffersEvent event) async* {
    if (event is StartOffersEvent) {
      yield LoadingOffersState();
      CustomResponse response = await _getRepo();
      if (response.success) {
        OffersModel _model = OffersModel.fromJson(response.response?.data);
        yield DoneOffersState(response.msg, _model.data);
      } else {
        yield FaildOffersState(msg: response.msg, errType: response.errType!, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> _getRepo() async {
    CustomResponse response = await serverGate.getFromServer(url: "client/offers");
    return response;
  }
}
