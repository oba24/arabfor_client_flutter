import '../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCategoryProvidersBloc extends Bloc<GetCategoryProvidersEvent, GetCategoryProvidersState> {
  GetCategoryProvidersBloc() : super(GetCategoryProvidersState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<GetCategoryProvidersState> mapEventToState(GetCategoryProvidersEvent event) async* {
    if (event is StartGetCategoryProvidersEvent) {
      yield LoadingGetCategoryProvidersState();
      CustomResponse response = await repo(event.id);
      if (response.success) {
        CategoryProvidersModel _model = CategoryProvidersModel.fromJson(response.response?.data);
        yield DoneGetCategoryProvidersState(response.msg, _model.data);
      } else {
        yield FaildGetCategoryProvidersState(msg: response.msg, errType: response.errType ?? 1);
      }
    }
  }

  Future<CustomResponse> repo(int id) async {
    CustomResponse response = await serverGate.getFromServer(
      url: "client/all_provider?category_id=$id",
    );
    return response;
  }
}
