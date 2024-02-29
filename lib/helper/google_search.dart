import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saudimarchclient/repo/server_gate.dart';

// ignore: non_constant_identifier_names
String APIKEY = "AIzaSyAt3tepDJmYHcGdzMQKbXEFpovaP2MmtdI";

class SearchGoogleModel {
  SearchGoogleModel({
    required this.formattedAddress,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.placeId,
    required this.reference,
    required this.types,
  });

  String formattedAddress;
  GeometryData geometry;
  String icon;
  String iconBackgroundColor;
  String iconMaskBaseUri;
  String name;
  String placeId;
  String reference;
  List<String> types;

  factory SearchGoogleModel.fromJson(Map<String, dynamic> json) => SearchGoogleModel(
        formattedAddress: json["formatted_address"] ?? "",
        geometry: GeometryData.fromJson(json["geometry"] ?? {}),
        icon: json["icon"] ?? "",
        iconBackgroundColor: json["icon_background_color"] ?? "",
        iconMaskBaseUri: json["icon_mask_base_uri"] ?? "",
        name: json["name"] ?? "",
        placeId: json["place_id"] ?? "",
        reference: json["reference"] ?? "",
        types: List<String>.from((json["types"] ?? []).map((x) => x)),
      );
}

class GeometryData {
  GeometryData({
    required this.location,
    required this.viewport,
  });

  LocationData location;
  ViewportData viewport;

  factory GeometryData.fromJson(Map<String, dynamic> json) => GeometryData(
        location: LocationData.fromJson(json["location"] ?? {}),
        viewport: ViewportData.fromJson(json["viewport"] ?? {}),
      );
}

class ViewportData {
  ViewportData({
    required this.northeast,
    required this.southwest,
  });

  LocationData northeast;
  LocationData southwest;

  factory ViewportData.fromJson(Map<String, dynamic> json) => ViewportData(
        northeast: LocationData.fromJson(json["northeast"] ?? {}),
        southwest: LocationData.fromJson(json["southwest"] ?? {}),
      );
}

class LocationData {
  LocationData({
    required this.latLng,
  });

  LatLng latLng;

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(latLng: LatLng(json["lat"] ?? 0, json["lng"] ?? 0));
}

class GoogleApisHelper {
  final ServerGate _serverGate = ServerGate();

  Future<List<SearchGoogleModel>> searchGoogle(String input) async {
    try {
      CustomResponse response = await _serverGate.getFromServer(url: "https://maps.googleapis.com/maps/api/place/textsearch/json", params: {
        "language": "ar",
        "query": input,
        "key": APIKEY,
      });
      return List<SearchGoogleModel>.from((response.response?.data["results"] ?? []).map((x) => SearchGoogleModel.fromJson(x)));
    } catch (e) {
      return [];
    }
  }
}
