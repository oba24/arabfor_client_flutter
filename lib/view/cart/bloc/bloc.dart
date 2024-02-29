import '../../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is StartGetCartEvent) {
      yield LoadingCartState(type: 'start');
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await getRepo();
      if (response.success) {
        CartModel _model = CartModel.fromJson(response.response?.data);
        // await CustomProgressDialog.hidePr();
        yield DoneGetCartState(response.msg, _model);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildCartState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
    if (event is StartControllerCartEvent) {
      yield LoadingCartState(type: event.type);
      CustomResponse response = await updateRepo(event);
      if (response.success) {
        CartModel _model = CartModel.fromJson(response.response?.data);
        yield DoneControllerCartState(response.msg, _model);
      } else {
        yield FaildCartState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
    if (event is StartApplyCouponEvent) {
      yield LoadingCartState(type: 'coupon');
      CustomResponse response = await _couponRepo(event.text);
      if (response.success) {
        CartModel _model = CartModel.fromJson(response.response?.data);
        yield DoneControllerCartState(response.msg, _model);
      } else {
        yield FaildCartState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> getRepo() async {
    CustomResponse response = await serverGate.getFromServer(url: "client/get_cart");
    return response;
  }

  Future<CustomResponse> _couponRepo(String text) async {
    CustomResponse response = await serverGate.getFromServer(url: "client/apply_coupon/$text");
    return response;
  }

  Future<CustomResponse> updateRepo(StartControllerCartEvent event) async {
    CustomResponse response = await serverGate.sendToServer(url: event.url, body: event.body);
    return response;
  }
}
