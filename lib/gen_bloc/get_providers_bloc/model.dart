// To parse this JSON data, do
//
//     final colorsModel = colorsModelFromJson(jsonString);

import '../../models/category_provider_model.dart';

class CategoryProvidersModel {
  CategoryProvidersModel({
    required this.data,
    required this.status,
    required this.message,
  });

  List<CategoryProviderDatum> data;
  String status;
  String message;

  factory CategoryProvidersModel.fromJson(Map<String, dynamic> json) => CategoryProvidersModel(
        data: List<CategoryProviderDatum>.from((json["data"] ?? []).map((x) => CategoryProviderDatum.fromJson(x))),
        status: json["status"] ?? "",
        message: json["message"] ?? "",
      );
}
