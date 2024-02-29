// To parse this JSON data, do
//
//     final payTypeModel = payTypeModelFromJson(jsonString);

import 'dart:convert';

RatesModel payTypeModelFromJson(String str) => RatesModel.fromJson(json.decode(str));

class RatesModel {
  RatesModel({required this.id, required this.name});

  int id;
  String name;

  factory RatesModel.fromJson(Map<String, dynamic> json) => RatesModel(id: json["id"] ?? -1, name: json["name"] ?? '');
}

ClassificationModel classificationModelFromJson(String str) => ClassificationModel.fromJson(json.decode(str));

class ClassificationModel {
  ClassificationModel({required this.id, required this.name, required this.key});

  int id;
  String name;
  String key;

  factory ClassificationModel.fromJson(Map<String, dynamic> json) =>
      ClassificationModel(id: json["id"] ?? -1, name: json["name"] ?? '', key: json["key"] ?? '');
}
