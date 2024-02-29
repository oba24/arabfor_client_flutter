// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

import 'package:saudimarchclient/models/product_data.dart';

SearchModel searchModelFromJson(String str) => SearchModel.fromJson(json.decode(str));

class SearchModel {
  SearchModel({
    required this.data,
    required this.status,
    required this.message,
  });

  List<ProductData> data;
  String status;
  String message;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        data: List<ProductData>.from((json["data"] ?? []).map((x) => ProductData.fromJson(x))),
        status: json["status"] ?? '',
        message: json["message"] ?? '',
      );
}
