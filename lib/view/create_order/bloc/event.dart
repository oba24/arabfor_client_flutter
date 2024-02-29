import 'package:flutter/material.dart';
import 'package:saudimarchclient/helper/user_data.dart';

class CreateOrderEvent {}

class StartCreateOrderEvent extends CreateOrderEvent {
  late TextEditingController clientName;
  late TextEditingController phone;
  late String payType;
  late int shippingId;
  late int addressId;
  late GlobalKey<FormState> formKey;

  StartCreateOrderEvent() {
    formKey = GlobalKey();
    clientName = TextEditingController(text: UserHelper.userDatum.userName);
    phone = TextEditingController(text: UserHelper.userDatum.phone);
    payType = '';
    shippingId = 0;
    addressId = 0;
  }
  Map<String, dynamic> get body => {
        "client_name": clientName.text,
        "phone": phone.text,
        "pay_type": payType,
        "shipping_type_id": shippingId,
        "address_id": addressId,
      };
}
