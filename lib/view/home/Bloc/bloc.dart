import 'home_model.dart';
import '../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is StartHomeEvent) {
      // show loader ........ ?

      yield LoadingHomeState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo();

      if (response.success) {
        HomeModel _model = HomeModel.fromJson(
          response.response?.data,
        );

        // await CustomProgressDialog.hidePr();
        yield DoneHomeState(response.msg, _model);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildHomeState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> repo() async {
    CustomResponse response = await serverGate.getFromServer(
      url: "client/home",
    );
    return response;
  }
}
