import '../../models/citys_model.dart';
import '../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CitiesBloc extends Bloc<CitiesEvent, CitiesState> {
  CitiesBloc() : super(CitiesState());
  ServerGate serverGate = ServerGate();
  List<CitiesModel>? cities;

  @override
  Stream<CitiesState> mapEventToState(CitiesEvent event) async* {
    if (event is StartCitiesEvent) {
      // show loader ........ ?
      if (cities != null) {
        yield DoneCitiesState("", cities!);
      } else {
        yield LoadingCitiesState();
        // await CustomProgressDialog.showProgressDialog();
        CustomResponse response = await repo();

        if (response.success) {
          cities = List<CitiesModel>.from((response.response!.data["data"] ?? []).map((x) => CitiesModel.fromJson(x)));

          // await CustomProgressDialog.hidePr();
          yield DoneCitiesState(response.msg, cities!);
        } else {
          // await CustomProgressDialog.hidePr();
          yield FaildCitiesState(
            msg: response.msg,
            errType: response.errType ?? 0,
          );
        }
      }
    }
  }

  Future<CustomResponse> repo() async {
    CustomResponse response = await serverGate.getFromServer(
      url: "cities",
    );
    return response;
  }
}
