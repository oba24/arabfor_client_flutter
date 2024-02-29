import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import '../../../../helper/user_data.dart';

class UpdateProfileEvent {}

class StartUpdateProfileEvent extends UpdateProfileEvent {
  late TextEditingController mobile, fullName, email, addressName;

  late File image;

  Map<String, dynamic> get body => {
        "fullname": fullName.text,
        "email": email.text,
        "phone": mobile.text,
        if (!image.path.contains("http"))
          "image": MultipartFile.fromFileSync(image.path),
      };

  StartUpdateProfileEvent() {
    mobile = TextEditingController(text: UserHelper.userDatum.phone);
    email = TextEditingController(text: UserHelper.userDatum.email);
    fullName = TextEditingController(text: UserHelper.userDatum.userName);
    image = File(UserHelper.userDatum.image);
  }
}

class StartEditPasswordEvent extends UpdateProfileEvent {
  late TextEditingController newPassword, confairmNewPawword, currntPassword;
  late GlobalKey<FormState> formKey;
  Map<String, dynamic> get body =>
      {"old_password": currntPassword.text, "password": newPassword.text};

  StartEditPasswordEvent() {
    newPassword = TextEditingController();
    confairmNewPawword = TextEditingController();
    currntPassword = TextEditingController();
    formKey = GlobalKey();
  }
}
