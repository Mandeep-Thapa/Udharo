import 'dart:convert';

List<BorrowHistoryModel> borrowHistoryModelFromJson(String str) =>
    List<BorrowHistoryModel>.from(
        json.decode(str).map((x) => BorrowHistoryModel.fromJson(x)));

String borrowHistoryModelToJson(List<BorrowHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BorrowHistoryModel {
  String? id;
  String? borrower;
  String? fullName;
  int? riskFactor;
  int? amount;
  String? purpose;
  int? interestRate;
  int? paybackPeriod;
  String? status;
  DateTime? createdAt;
  int? v;

  BorrowHistoryModel({
    this.id,
    this.borrower,
    this.fullName,
    this.riskFactor,
    this.amount,
    this.purpose,
    this.interestRate,
    this.paybackPeriod,
    this.status,
    this.createdAt,
    this.v,
  });

  factory BorrowHistoryModel.fromJson(Map<String, dynamic> json) =>
      BorrowHistoryModel(
        id: json["_id"],
        borrower: json["borrower"],
        fullName: json["fullName"],
        riskFactor: json["riskFactor"],
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
        "fullName": fullName,
        "riskFactor": riskFactor,
        "amount": amount,
        "purpose": purpose,
        "interestRate": interestRate,
        "paybackPeriod": paybackPeriod,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };
}
