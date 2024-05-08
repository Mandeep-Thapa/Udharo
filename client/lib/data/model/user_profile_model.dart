import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  String? status;
  Data? data;

  UserProfileModel({
    this.status,
    this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  String? userName;
  String? userId;
  String? email;
  IsVerified? isVerified;
  int? riskFactor;

  Data({
    this.userName,
    this.userId,
    this.email,
    this.isVerified,
    this.riskFactor,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userName: json["userName"],
        userId: json["userId"],
        email: json["email"],
        isVerified: json["isVerified"] == null
            ? null
            : IsVerified.fromJson(json["isVerified"]),
        riskFactor: json["riskFactor"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userId": userId,
        "email": email,
        "isVerified": isVerified?.toJson(),
        "riskFactor": riskFactor,
      };
}

class IsVerified {
  bool? isEmailVerified;
  bool? isKycVerified;
  bool? isPanVerified;

  IsVerified({
    this.isEmailVerified,
    this.isKycVerified,
    this.isPanVerified,
  });

  factory IsVerified.fromJson(Map<String, dynamic> json) => IsVerified(
        isEmailVerified: json["is_emailVerified"],
        isKycVerified: json["is_kycVerified"],
        isPanVerified: json["is_panVerified"],
      );

  Map<String, dynamic> toJson() => {
        "is_emailVerified": isEmailVerified,
        "is_kycVerified": isKycVerified,
        "is_panVerified": isPanVerified,
      };
}
