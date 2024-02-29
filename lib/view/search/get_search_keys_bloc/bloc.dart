import 'package:saudimarchclient/repo/server_gate.dart';

import 'model.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchKeysBloc extends Bloc<SearchKeysEvent, SearchKeysState> {
  SearchKeysBloc() : super(SearchKeysState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<SearchKeysState> mapEventToState(SearchKeysEvent event) async* {
    if (event is StartSearchKeysEvent) {
      // show loader ........ ?

      yield LoadingSearchKeysState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo();

      if (response.success) {
        SearchKeysModel _model = SearchKeysModel.fromJson(
          response.response?.data,
        );

        // await CustomProgressDialog.hidePr();
        yield DoneSearchKeysState(response.msg, _model);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildSearchKeysState(
          msg: response.msg,
          errType: response.errType ?? 0,
        );
      }
    }
  }

  Future<CustomResponse> repo() async {
    CustomResponse response = await serverGate.getFromServer(
      url: "search_history",
    );
    return response;
  }
}
