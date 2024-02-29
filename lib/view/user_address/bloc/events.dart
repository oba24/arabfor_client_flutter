import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saudimarchclient/helper/location_helper.dart';

class UserAddresEvent {}

class StartAddAddresEvent extends UserAddresEvent {
  late LatLng latLng;
  late TextEditingController title;
  String? address;
  Future<Map<String, dynamic>> get body async {
    if (address == null) {
      var place = await LocationHelper.getPlacemarks(latLng);
      address = place.street;
    }
    return {
      "name": title.text,
      "lat": latLng.latitude,
      "lng": latLng.longitude,
      "address": address,
      "is_default": 0,
    };
  }

  StartAddAddresEvent() {
    latLng = const LatLng(26.549999, 31.700001);
    title = TextEditingController();
  }
}

class StartGetAddressesEvent extends UserAddresEvent {
  StartGetAddressesEvent();
}

class StartIsDefaultEvent extends UserAddresEvent {
  int id;
  StartIsDefaultEvent(this.id);
}

class StartDeleteEvent extends UserAddresEvent {
  int id;
  StartDeleteEvent(this.id);
}
