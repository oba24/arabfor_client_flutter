class UserModel {
  UserModel({
    required this.id,
    required this.userType,
    required this.userName,
    required this.phone,
    required this.email,
    required this.image,
    required this.logo,
    required this.lastLoginAt,
    required this.token,
  });

  int id;
  String userType;
  String userName;
  String phone;
  String email;
  String image;
  String logo;
  String lastLoginAt;
  TokenDatum token;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ?? 0,
        userType: json["user_type"] ?? "",
        userName: json["user_name"] ?? "",
        phone: json["phone"] ?? "",
        email: json["email"] ?? "",
        image: json["image"] ?? "",
        logo: json["logo"] ?? "",
        lastLoginAt: json["last_login_at"] ?? "",
        token: TokenDatum.fromJson(json["token"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_type": userType,
        "user_name": userName,
        "phone": phone,
        "email": email,
        "image": image,
        "logo": logo,
        "last_login_at": lastLoginAt,
        "token": token.toJson(),
      };
}

class TokenDatum {
  TokenDatum({
    required this.tokenType,
    required this.accessToken,
  });

  String tokenType;
  String accessToken;

  factory TokenDatum.fromJson(Map<String, dynamic> json) => TokenDatum(
        tokenType: json["token_type"] ?? "",
        accessToken: json["access_token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "access_token": accessToken,
      };
}
