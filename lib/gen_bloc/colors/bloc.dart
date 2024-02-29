import '../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsBloc extends Bloc<ColorsEvent, ColorsState> {
  ColorsBloc() : super(ColorsState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<ColorsState> mapEventToState(ColorsEvent event) async* {
    if (event is StartColorsEvent) {
      yield LoadingColorsState();
      CustomResponse response = await repo();
      if (response.success) {
        ColorsModel _model = ColorsModel.fromJson(response.response?.data);
        yield DoneColorsState(response.msg, _model.data);
      } else {
        yield FaildColorsState(msg: response.msg, errType: response.errType ?? 1);
      }
    }
  }

  Future<CustomResponse> repo() async {
    CustomResponse response = await serverGate.getFromServer(
      url: "colors",
    );
    return response;
  }
}
