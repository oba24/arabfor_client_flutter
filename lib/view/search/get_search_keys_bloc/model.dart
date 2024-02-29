// To parse this JSON data, do
//
//     final searchKeysModel = searchKeysModelFromJson(jsonString);

import 'dart:convert';

SearchKeysModel searchKeysModelFromJson(String str) => SearchKeysModel.fromJson(json.decode(str));

class SearchKeysModel {
  SearchKeysModel({
    required this.data,
    required this.status,
    required this.message,
  });

  List<Datum> data;
  String status;
  String message;

  factory SearchKeysModel.fromJson(Map<String, dynamic> json) => SearchKeysModel(
        data: List<Datum>.from((json["data"] ?? []).map((x) => Datum.fromJson(x))),
        status: json["status"] ?? '',
        message: json["message"] ?? '',
      );
}

class Datum {
  Datum({
    required this.id,
    required this.key,
  });

  int id;
  String key;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        key: json["key"] ?? '',
      );
}
