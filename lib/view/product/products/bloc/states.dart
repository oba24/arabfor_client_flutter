import 'model.dart';

class CategoryProductsState {}

class LoadingCategoryProductsState extends CategoryProductsState {}

class FaildCategoryProductsState extends CategoryProductsState {
  String msg;
  int errType;
  int statusCode;
  FaildCategoryProductsState({required this.errType, required this.msg, required this.statusCode});
}

class DoneCategoryProductsState extends CategoryProductsState {
  String msg;
  CategoryProductsModel model;
  DoneCategoryProductsState(this.msg, this.model);
}
