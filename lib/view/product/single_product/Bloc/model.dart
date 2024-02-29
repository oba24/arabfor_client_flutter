// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

import 'package:saudimarchclient/models/product_data.dart';

ProductDetailModel homeModelFromJson(String str) =>
    ProductDetailModel.fromJson(json.decode(str));

class ProductDetailModel {
  ProductDetailModel({
    required this.data,
    required this.status,
    required this.message,
  });

  ProductData data;
  String status;
  String message;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        data: ProductData.fromJson(json["data"] ?? {}),
        status: json["status"] ?? '',
        message: json["message"] ?? '',
      );
}
