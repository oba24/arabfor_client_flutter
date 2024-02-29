import 'package:saudimarchclient/repo/server_gate.dart';
import 'package:saudimarchclient/view/filter/view.dart';

import 'model.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryProductsBloc extends Bloc<CategoryProductsEvent, CategoryProductsState> {
  CategoryProductsBloc() : super(CategoryProductsState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<CategoryProductsState> mapEventToState(CategoryProductsEvent event) async* {
    if (event is StartCategoryProductsEvent) {
      // show loader ........ ?

      yield LoadingCategoryProductsState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(id: event.id, subCategoryId: event.subCategoryId, type: event.type, filterData: event.filterData);

      if (response.success) {
        CategoryProductsModel _model = CategoryProductsModel.fromJson(
          response.response?.data,
        );

        // await CustomProgressDialog.hidePr();
        yield DoneCategoryProductsState(response.msg, _model);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildCategoryProductsState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    } else if (event is UpdatetCategoryProductsEvent) {
      // show loader ........ ?

      // yield LoadingCategoryProductsState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(id: event.id, subCategoryId: event.subCategoryId);

      if (response.success) {
        CategoryProductsModel _model = CategoryProductsModel.fromJson(
          response.response?.data,
        );

        // await CustomProgressDialog.hidePr();
        yield DoneCategoryProductsState(response.msg, _model);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildCategoryProductsState(msg: response.msg, errType: response.errType ?? 0, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> repo({required int id, dynamic subCategoryId, String type = '', FilterData? filterData}) async {
    CustomResponse response = await serverGate.getFromServer(
      url: filterData != null
          ? 'filter'
          : type == 'latest_added'
              ? 'get_products?type=latest_added'
              : type == 'best_seller'
                  ? 'get_products?type=best_seller'
                  : subCategoryId == null
                      ? "categories/$id?sub_category_id=all"
                      : "categories/$id?sub_category_id=$subCategoryId",
      params: filterData == null ? null : filterData.toJson(),
    );

    return response;
  }
}
