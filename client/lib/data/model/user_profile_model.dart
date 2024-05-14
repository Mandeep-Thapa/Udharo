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
  String? risk;

  Data({
    this.userName,
    this.userId,
    this.email,
    this.isVerified,
    this.riskFactor,
    this.risk,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userName: json["userName"],
        userId: json["userId"],
        email: json["email"],
        isVerified: json["isVerified"] == null
            ? null
            : IsVerified.fromJson(json["isVerified"]),
        riskFactor: json["riskFactor"],
        risk: mapRisk(json["riskFactor"]),
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userId": userId,
        "email": email,
        "isVerified": isVerified?.toJson(),
        "riskFactor": riskFactor,
      };

  static String mapRisk(int? riskFactor) {
    if (riskFactor == 1) {
      return 'Very High';
    } else if (riskFactor == 2) {
      return 'High';
    } else if (riskFactor == 3) {
      return 'Moderately High';
    } else if (riskFactor == 4) {
      return 'Low';
    } else if (riskFactor == 5) {
      return 'Very Low';
    } else {
      return 'Unknown';
    }
  }
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
