// To parse this JSON data, do
//
//     final payTypeModel = payTypeModelFromJson(jsonString);

import 'dart:convert';

PayTypeModel payTypeModelFromJson(String str) =>
    PayTypeModel.fromJson(json.decode(str));

class PayTypeModel {
  PayTypeModel({
    required this.id,
    required this.name,
    required this.key,
  });

  int id;
  String name;
  String key;

  factory PayTypeModel.fromJson(Map<String, dynamic> json) => PayTypeModel(
        id: json["id"] ?? -1,
        name: json["name"] ?? '',
        key: json["key"] ?? '',
      );
}
