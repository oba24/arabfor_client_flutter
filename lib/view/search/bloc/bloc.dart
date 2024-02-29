import 'package:saudimarchclient/repo/server_gate.dart';

import 'model.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is StartSearchEvent) {
      // show loader ........ ?

      yield LoadingSearchState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(event.id);

      if (response.success) {
        SearchModel _model = SearchModel.fromJson(
          response.response?.data,
        );

        // await CustomProgressDialog.hidePr();
        yield DoneSearchState(response.msg, _model);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildSearchState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> repo(dynamic id) async {
    CustomResponse response = await serverGate.getFromServer(url: "search?keyword=$id", params: {"type": false});
    return response;
  }
}
