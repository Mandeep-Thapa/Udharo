import 'dart:convert';

UserProfileModel userProfileFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileToJson(UserProfileModel data) => json.encode(data.toJson());

// model class to represent user profile data
class UserProfileModel {
  String? status;
  Data? data;

  UserProfileModel({
    this.status,
    this.data,
  });

  // deserialize JSON to UserProfile object
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  // serialize UserProfile object to JSON
  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

// model class to represent user data
class Data {
  String? userId;
  String? email;
  bool? isVerified;
  int? riskFactor;

  Data({
    this.userId,
    this.email,
    this.isVerified,
    this.riskFactor,
  });

  // deserialize JSON to Data object
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        email: json["email"],
        isVerified: json["isVerified"],
        riskFactor: json["riskFactor"],
      );

  // serialize Data object to JSON
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "isVerified": isVerified,
        "riskFactor": riskFactor,
      };
}
