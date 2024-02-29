import '../../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is StartFavoriteEvent) {
      yield LoadingFavoriteState();
      CustomResponse response = await _getRepo();
      if (response.success) {
        FavoriteModel _model = FavoriteModel.fromJson(response.response?.data);
        yield DoneFavoriteState(response.msg, _model.data);
      } else {
        yield FaildFavoriteState(msg: response.msg, errType: response.errType!, statusCode: response.statusCode);
      }
    }
    if (event is StartFavoriteControllerEvent) {
      yield LoadingFavoriteState();
      CustomResponse response = await _controllerRepo(event.body);
      if (response.success) {
        // FavoriteModel _model = FavoriteModel.fromJson(response.response.data);
        yield DoneFavoriteControllerState(response.msg);
      } else {
        yield FaildFavoriteState(msg: response.msg, errType: response.errType!, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> _getRepo() async {
    CustomResponse response = await serverGate.getFromServer(url: "client/favorite_products");
    return response;
  }

  Future<CustomResponse> _controllerRepo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "client/favorite_products", body: body);
    return response;
  }
}
