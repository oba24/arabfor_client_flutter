import 'package:saudimarchclient/view/filter/view.dart';

class CategoryProductsEvent {}

class StartCategoryProductsEvent extends CategoryProductsEvent {
  final dynamic id;
  final dynamic subCategoryId;
  final String type;
  final FilterData? filterData;

  StartCategoryProductsEvent({
    this.id,
    this.subCategoryId,
    required this.type,
    this.filterData,
  });
}

class UpdatetCategoryProductsEvent extends CategoryProductsEvent {
  final dynamic id;
  final dynamic subCategoryId;

  UpdatetCategoryProductsEvent({this.id, this.subCategoryId});
}
