import 'package:flutter/material.dart';

class RegisterEvent {}

class StartRegisterEvent extends RegisterEvent {
  late TextEditingController mobile, password, userName, email, confirmPassword;
  late GlobalKey<FormState> formKey;

  Map<String, dynamic> toJson() => {
        "password": password.text,
        "user_name": userName.text,
        "email": email.text,
        "phone": mobile.text,
        "password_confirmation": confirmPassword.text,
      };

  StartRegisterEvent() {
    formKey = GlobalKey();
    mobile = TextEditingController();
    password = TextEditingController();
    userName = TextEditingController();
    email = TextEditingController();
    confirmPassword = TextEditingController();
  }
}
