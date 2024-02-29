import '../../../models/addres_model.dart';

class AddressModel {
  AddressModel({
    required this.data,
    required this.links,
    required this.message,
    required this.single,
  });

  List<AddressDatum> data;
  AddressDatum single;
  _Links links;
  String message;

  factory AddressModel.fromJson(Map<String, dynamic> json, {bool isSingle = false}) => AddressModel(
        data: List<AddressDatum>.from((!isSingle ? (json["data"] ?? []) : []).map((x) => AddressDatum.fromJson(x))),
        single: AddressDatum.fromJson(isSingle ? (json["data"] ?? {}) : {}),
        links: _Links.fromJson((json["links"] ?? {})),
        message: json["message"] ?? "",
      );
}

class _Links {
  _Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String? first;
  String? last;
  String? prev;
  String? next;

  factory _Links.fromJson(Map<String, dynamic> json) => _Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );
}
