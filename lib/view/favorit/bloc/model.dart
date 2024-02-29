import 'package:saudimarchclient/models/product_data.dart';

class FavoriteModel {
  FavoriteModel({
    required this.data,
  });

  List<ProductData> data;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        data: List<ProductData>.from((json["data"] ?? []).map((x) => ProductData.fromJson(x))),
      );
}
