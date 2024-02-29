// To parse this JSON data, do
//
//     final sliderData = sliderDataFromJson(jsonString);

import 'dart:convert';

SliderData sliderDataFromJson(String str) =>
    SliderData.fromJson(json.decode(str));

String sliderDataToJson(SliderData data) => json.encode(data.toJson());

class SliderData {
  SliderData({
    required this.id,
    required this.type,
    required this.name,
    required this.image,
  });

  int id;
  String type;
  String name;
  String image;

  factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
        id: json["id"] ?? 0,
        type: json["type"] ?? '',
        name: json["name"] ?? '',
        image: json["image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "image": image,
      };
}
