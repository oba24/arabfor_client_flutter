import 'package:saudimarchclient/models/product_data.dart';

class OffersModel {
  OffersModel({
    required this.data,
    required this.status,
    required this.message,
  });

  List<ProductData> data;
  String status, message;

  factory OffersModel.fromJson(Map<String, dynamic> json) => OffersModel(
        data: List<ProductData>.from((json["data"] ?? []).map((x) => ProductData.fromJson(x))),
        status: json["status"] ?? '',
        message: json["message"] ?? '',
      );
}
