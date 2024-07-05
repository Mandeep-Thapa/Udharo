import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  final String? status;
  final Data? data;

  UserProfileModel({
    this.status,
    this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  final String? userName;
  final String? userId;
  final String? email;
  final int? phoneNumber;
  final IsVerified? isVerified;
  final bool? hasActiveTransaction;
  final int? riskFactor;
  final String? risk;
  final num? moneyInvestedDetails;
  final String? userRole;
  final List<Transaction>? transactions;

  Data({
    this.userName,
    this.userId,
    this.email,
    this.phoneNumber,
    this.isVerified,
    this.hasActiveTransaction,
    this.riskFactor,
    this.risk,
    this.moneyInvestedDetails,
    this.userRole,
    this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userName: json["userName"],
    userId: json["userId"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    isVerified: json["isVerified"] == null ? null : IsVerified.fromJson(json["isVerified"]),
    hasActiveTransaction: json["hasActiveTransaction"],
    riskFactor: json["riskFactor"],
    risk: mapRisk(json["riskFactor"]),
    moneyInvestedDetails: json["moneyInvestedDetails"],
    userRole: json["userRole"],
    transactions: json["transactions"] == null
        ? null
        : List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "userId": userId,
    "email": email,
    "phoneNumber": phoneNumber,
    "isVerified": isVerified?.toJson(),
    "hasActiveTransaction": hasActiveTransaction,
    "riskFactor": riskFactor,
    "moneyInvestedDetails": moneyInvestedDetails,
    "userRole": userRole,
    "transactions": transactions == null
        ? null
        : List<dynamic>.from(transactions!.map((x) => x.toJson())),
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

class Transaction {
  final String? transaction;
  final int? amount;
  final num? interestRate;
  final int? paybackPeriod;
  final num? returnAmount;
  final String? borrowerName;
  final num? fulfilledAmount;

  Transaction({
    this.transaction,
    this.amount,
    this.interestRate,
    this.paybackPeriod,
    this.returnAmount,
    this.borrowerName,
    this.fulfilledAmount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    transaction: json["transaction"],
    amount: json["amount"],
    interestRate: json["interestRate"],
    paybackPeriod: json["paybackPeriod"],
    returnAmount: json["returnAmount"],
    borrowerName: json["borrowerName"],
    fulfilledAmount: json["fulfilledAmount"],
  );

  Map<String, dynamic> toJson() => {
    "transaction": transaction,
    "amount": amount,
    "interestRate": interestRate,
    "paybackPeriod": paybackPeriod,
    "returnAmount": returnAmount,
    "borrowerName": borrowerName,
    "fulfilledAmount": fulfilledAmount,
  };
}

class IsVerified {
  final bool? isEmailVerified;
  final bool? isKycVerified;
  final bool? isPanVerified;

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
