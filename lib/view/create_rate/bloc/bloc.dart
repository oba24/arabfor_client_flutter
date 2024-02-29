import 'package:saudimarchclient/repo/server_gate.dart';

import 'model.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRatingBloc extends Bloc<AddRatingEvent, AddRatingState> {
  AddRatingBloc() : super(AddRatingState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<AddRatingState> mapEventToState(AddRatingEvent event) async* {
    if (event is StartAddRatingEvent) {
      // show loader ........ ?

      yield LoadingAddRatingState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(id : event.id ,  comment: event.comment, ratingValue: event.ratingValue);

      if (response.success) {
        AddRatingModel _model = AddRatingModel.fromJson(
          response.response?.data,
        );

        // await CustomProgressDialog.hidePr();
        yield DoneAddRatingState(response.msg, _model);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildAddRatingState(
          msg: response.msg,
          errType: response.errType ?? 0,
        );
      }
    }
  }

  Future<CustomResponse> repo(
      {required int id,
      required num ratingValue,
      required String comment}) async {
    CustomResponse response = await serverGate.sendToServer(
      url: "client/rating",
      body: {"product_id": id, "rating_value": ratingValue, "comment": comment},
    );
    return response;
  }
}
