// To parse this JSON data, do
//
//     final categoryProductsModel = categoryProductsModelFromJson(jsonString);

import 'dart:convert';

import 'package:saudimarchclient/models/product_data.dart';

CategoryProductsModel categoryProductsModelFromJson(String str) => CategoryProductsModel.fromJson(json.decode(str));

class CategoryProductsModel {
  CategoryProductsModel({
    required this.data,
  });

  CategoryProductData data;

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) => CategoryProductsModel(
        data: CategoryProductData.fromJson(json["data"] ?? {}),
      );
}

class CategoryProductData {
  CategoryProductData({
    required this.subCategory,
    required this.products,
  });

  List<CategoryData> subCategory;
  List<ProductData> products;

  factory CategoryProductData.fromJson(Map<String, dynamic> json) => CategoryProductData(
        subCategory: List<CategoryData>.from((json["sub_category"] ?? []).map((x) => CategoryData.fromJson(x))),
        products: List<ProductData>.from((json["products"] ?? []).map((x) => ProductData.fromJson(x))),
      );
}
