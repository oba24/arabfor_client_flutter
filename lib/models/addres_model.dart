import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressDatum {
  AddressDatum({
    required this.id,
    required this.name,
    required this.latLng,
    required this.address,
    required this.isDefault,
  });

  int id;
  String name;
  LatLng latLng;
  String address;
  bool isDefault;

  factory AddressDatum.fromJson(Map<String, dynamic> json) => AddressDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        latLng: LatLng(double.parse((json["lat"] ?? "0").toString()), double.parse((json["lng"] ?? "0").toString())),
        address: json["address"] ?? "",
        isDefault: json["is_default"] ?? false,
      );
}
