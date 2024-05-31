import 'dart:convert';

ViewKycModel viewKycModelFromJson(String str) =>
    ViewKycModel.fromJson(json.decode(str));

String viewKycModelToJson(ViewKycModel data) => json.encode(data.toJson());

class ViewKycModel {
  String? message;
  Data? data;

  ViewKycModel({
    this.message,
    this.data,
  });

  factory ViewKycModel.fromJson(Map<String, dynamic> json) => ViewKycModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? id;
  String? userId;
  String? firstName;
  String? lastName;
  String? gender;
  String? photo;
  int? citizenshipNumber;
  String? panNumber;
  String? citizenshipFrontPhoto;
  String? citizenshipBackPhoto;
  bool? isKycVerified;

  Data({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.photo,
    this.citizenshipNumber,
    this.panNumber,
    this.citizenshipFrontPhoto,
    this.citizenshipBackPhoto,
    this.isKycVerified,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        gender: json["gender"],
        photo: json["photo"],
        citizenshipNumber: json["citizenshipNumber"],
        panNumber: json["panNumber"],
        citizenshipFrontPhoto: json["citizenshipFrontPhoto"],
        citizenshipBackPhoto: json["citizenshipBackPhoto"],
        isKycVerified: json["isKYCVerified"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "photo": photo,
        "citizenshipNumber": citizenshipNumber,
        "citizenshipFrontPhoto": citizenshipFrontPhoto,
        "citizenshipBackPhoto": citizenshipBackPhoto,
        "isKYCVerified": isKycVerified,
      };
}
