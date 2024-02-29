// To parse this JSON data, do
//
//     final storeDetailModel = storeDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:saudimarchclient/models/product_data.dart';

StoreDetailModel storeDetailModelFromJson(String str) => StoreDetailModel.fromJson(json.decode(str));

class StoreDetailModel {
  StoreDetailModel({
    required this.data,
    required this.status,
    required this.message,
  });

  StoreData data;
  String status;
  String message;

  factory StoreDetailModel.fromJson(Map<String, dynamic> json) => StoreDetailModel(
        data: StoreData.fromJson(json["data"] ?? {}),
        status: json["status"] ?? '',
        message: json["message"] ?? '',
      );
}

class StoreData {
  StoreData({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.products,
  });

  int id;
  String name;
  String desc;
  String image;
  List<ProductData> products;

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        desc: json["desc"] ?? '',
        image: json["image"] ?? '',
        products: List<ProductData>.from((json["products"] ?? []).map((x) => ProductData.fromJson(x))),
      );
}
