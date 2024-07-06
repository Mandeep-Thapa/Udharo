import 'dart:convert';

import 'package:udharo/constants/enums.dart';

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
  String? fullName;
  int? riskFactor;
  String? risk;
  int? amount;
  int? amountRemaining;
  String? purpose;
  num? interestRate;
  int? paybackPeriod;
  String? status;

  BorrowRequest({
    this.id,
    this.borrower,
    this.fullName,
    this.riskFactor,
    this.amount,
    this.amountRemaining,
    this.purpose,
    this.interestRate,
    this.paybackPeriod,
    this.status,
    this.risk,
  });

  factory BorrowRequest.fromJson(Map<String, dynamic> json) => BorrowRequest(
        id: json["_id"],
        borrower: json["borrower"],
        fullName: json["fullName"],
        riskFactor: json["riskFactor"],
        amount: json["amount"],
        amountRemaining: json["amountRemaining"],
        purpose: json["purpose"],
        interestRate: json["interestRate"],
        paybackPeriod: json["paybackPeriod"],
        status: json["status"],
        risk: mapRisk(json["riskFactor"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "borrower": borrower,
        "fullName": fullName,
        "riskFactor": riskFactor,
        "amount": amount,
        "amountRemaining": amountRemaining,
        "purpose": purpose,
        "interestRate": interestRate,
        "paybackPeriod": paybackPeriod,
        "status": status,
      };

  static String mapRisk(int? riskFactor) {
    if (riskFactor == 1) {
      return RiskFactor.veryHigh.name;
    } else if (riskFactor == 2) {
      return RiskFactor.high.name;
    } else if (riskFactor == 3) {
      return RiskFactor.moderatelyHigh.name;
    } else if (riskFactor == 4) {
      return RiskFactor.low.name;
    } else if (riskFactor == 5) {
      return RiskFactor.veryLow.name;
    } else {
      return 'Unknown';
    }
  }
}
