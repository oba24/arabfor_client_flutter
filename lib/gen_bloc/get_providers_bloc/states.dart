import '../../models/category_provider_model.dart';

class GetCategoryProvidersState {}

class LoadingGetCategoryProvidersState extends GetCategoryProvidersState {}

class FaildGetCategoryProvidersState extends GetCategoryProvidersState {
  String msg;
  int errType;
  FaildGetCategoryProvidersState({required this.errType, required this.msg});
}

class DoneGetCategoryProvidersState extends GetCategoryProvidersState {
  List<CategoryProviderDatum> data;
  String msg;
  DoneGetCategoryProvidersState(this.msg, this.data);
}
