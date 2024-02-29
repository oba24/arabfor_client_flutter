import 'dart:convert';
import 'dart:developer';
import '../view/auth/login/view.dart';
import '../main.dart';
import '../models/user_model.dart';
import 'rout.dart';

class UserHelper {
  static String accessToken = "";
  static bool get isAuth => accessToken != "";
  static UserModel userDatum = UserModel.fromJson({});

  static setUserData(UserModel data) {
    userDatum = data;
    accessToken = data.token.accessToken;
    Prefs.setString("user_data", json.encode(data.toJson()));
  }

  static Future<bool> getUserData() async {
    String _data = Prefs.getString("user_data") ?? "";

    log("--------- Server Gate Logger --------> \x1B[37m------ User Data -----\x1B[0m");
    log("--------- Server Gate Logger --------> \x1B[32m${jsonEncode(_data)}\x1B[0m");
    if (_data != "") {
      userDatum = UserModel.fromJson(json.decode(_data));
      accessToken = userDatum.token.accessToken;
      log("--------- Server Gate Logger --------> \x1B[32m$accessToken\x1B[0m");
      return true;
    } else {
      userDatum = UserModel.fromJson({});
      accessToken = "";
      return false;
    }
  }

  static logout() {
    accessToken = "";
    userDatum = UserModel.fromJson({});
    Prefs.remove("user_data");
    pushAndRemoveUntil(const LoginView());
  }
}
