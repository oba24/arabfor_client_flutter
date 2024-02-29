// To parse this JSON data, do
//
//     final shippingModel = shippingModelFromJson(jsonString);

import 'dart:convert';

ShippingModel shippingModelFromJson(String str) =>
    ShippingModel.fromJson(json.decode(str));

// String shippingModelToJson(ShippingModel data) => json.encode(data.toJson());

class ShippingModel {
  ShippingModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.categoryImage,
  });

  int id;
  String name;
  String desc;
  String categoryImage;

  factory ShippingModel.fromJson(Map<String, dynamic> json) => ShippingModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        desc: json["desc"] ?? '',
        categoryImage: json["category_image"] ?? '',
      );
}
