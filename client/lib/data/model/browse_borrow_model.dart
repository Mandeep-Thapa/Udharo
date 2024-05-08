import 'dart:convert';

BrowseBorrowRequestModel browseBorrowRequestModelFromJson(String str) =>
    BrowseBorrowRequestModel.fromJson(json.decode(str));

String browseBorrowRequestModelToJson(BrowseBorrowRequestModel data) =>
    json.encode(data.toJson());

class BrowseBorrowRequestModel {
  String? status;
  Data? data;

  BrowseBorrowRequestModel({
    this.status,
    this.data,
  });

  factory BrowseBorrowRequestModel.fromJson(Map<String, dynamic> json) =>
      BrowseBorrowRequestModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  List<BorrowRequest>? borrowRequests;

  Data({
    this.borrowRequests,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        borrowRequests: json["borrowRequests"] == null
            ? []
            : List<BorrowRequest>.from(
                json["borrowRequests"]!.map((x) => BorrowRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "borrowRequests": borrowRequests == null
            ? []
            : List<dynamic>.from(borrowRequests!.map((x) => x.toJson())),
      };
}

class BorrowRequest {
  String? id;
  String? borrower;
  int? amount;
  String? purpose;
  int? interestRate;
  int? paybackPeriod;
  String? status;
  DateTime? createdAt;
  int? v;

  BorrowRequest({
    this.id,
    this.borrower,
    this.amount,
    this.purpose,
    this.interestRate,
    this.paybackPeriod,
    this.status,
    this.createdAt,
    this.v,
  });

  factory BorrowRequest.fromJson(Map<String, dynamic> json) => BorrowRequest(
        id: json["_id"],
        borrower: json["borrower"],
        amount: json["amount"],
        purpose: json["purpose"],
        interestRate: json["interestRate"],
        paybackPeriod: json["paybackPeriod"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "borrower": borrower,
        "amount": amount,
        "purpose": purpose,
        "interestRate": interestRate,
        "paybackPeriod": paybackPeriod,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };
}
