import 'package:saudimarchclient/repo/server_gate.dart';

import 'model.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<ProductDetailState> mapEventToState(ProductDetailEvent event) async* {
    if (event is StartProductDetailEvent) {
      // show loader ........ ?

      yield LoadingProductDetailState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(event.id);

      if (response.success) {
        ProductDetailModel _model = ProductDetailModel.fromJson(
          response.response?.data,
        );

        // await CustomProgressDialog.hidePr();
        yield DoneProductDetailState(response.msg, _model);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildProductDetailState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> repo(int id) async {
    CustomResponse response = await serverGate.getFromServer(
      url: "client/show_product/$id",
    );
    return response;
  }
}
