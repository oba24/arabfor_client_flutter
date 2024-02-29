// To parse this JSON data, do
//
//     final addRatingModel = addRatingModelFromJson(jsonString);

import 'dart:convert';

import 'package:saudimarchclient/models/product_data.dart';

AddRatingModel addRatingModelFromJson(String str) =>
    AddRatingModel.fromJson(json.decode(str));

class AddRatingModel {
  AddRatingModel({
    required this.status,
    required this.data,
    required this.message,
  });

  String status;
  ProductData data;
  String message;

  factory AddRatingModel.fromJson(Map<String, dynamic> json) => AddRatingModel(
        status: json["status"] ?? '',
        data: ProductData.fromJson(json["data"] ?? {}),
        message: json["message"] ?? '',
      );
}
