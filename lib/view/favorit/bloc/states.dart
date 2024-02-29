import '../../../models/product_data.dart';

class FavoriteState {}

class LoadingFavoriteState extends FavoriteState {}

class FaildFavoriteState extends FavoriteState {
  String msg;
  int errType;
  int statusCode;
  FaildFavoriteState({required this.errType, required this.msg, required this.statusCode});
}

class DoneFavoriteState extends FavoriteState {
  String msg;
  List<ProductData> data;

  DoneFavoriteState(this.msg, this.data);
}

class DoneFavoriteControllerState extends FavoriteState {
  String msg;
  DoneFavoriteControllerState(this.msg);
}
