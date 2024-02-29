// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

import '../../../models/product_data.dart';
import '../../../models/slider_model.dart';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

class HomeModel {
  HomeModel({
    required this.data,
    required this.status,
    required this.message,
  });

  HomeData data;
  String status;
  String message;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        data: HomeData.fromJson(json["data"] ?? {}),
        status: json["status"] ?? '',
        message: json["message"] ?? '',
      );
}

class HomeData {
  HomeData({
    required this.sliderHeader,
    required this.sliderBody,
    required this.mainCategory,
    required this.newerProductAdditions,
    required this.bestSeller,
  });

  List<SliderData> sliderHeader;
  List<SliderData> sliderBody;
  List<CategoryData> mainCategory;
  List<ProductData> newerProductAdditions;
  List<ProductData> bestSeller;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        sliderHeader: List<SliderData>.from((json["slider_header"] ?? []).map((x) => SliderData.fromJson(x))),
        sliderBody: List<SliderData>.from((json["slider_body"] ?? []).map((x) => SliderData.fromJson(x))),
        mainCategory: List<CategoryData>.from((json["main_category"] ?? []).map((x) => CategoryData.fromJson(x))),
        newerProductAdditions: List<ProductData>.from((json["newer_product_additions"] ?? []).map((x) => ProductData.fromJson(x))),
        bestSeller: List<ProductData>.from((json["best_seller"] ?? []).map((x) => ProductData.fromJson(x))),
      );
}
