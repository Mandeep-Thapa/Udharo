
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
    final IsVerified? isVerified;
    final bool? hasActiveTransaction;
    final int? riskFactor;
    final String? risk;
    final int? moneyInvestedDetails;

    Data({
        this.userName,
        this.userId,
        this.email,
        this.isVerified,
        this.hasActiveTransaction,
        this.riskFactor,
        this.risk,
        this.moneyInvestedDetails,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userName: json["userName"],
        userId: json["userId"],
        email: json["email"],
        isVerified: json["isVerified"] == null ? null : IsVerified.fromJson(json["isVerified"]),
        hasActiveTransaction: json["hasActiveTransaction"],
        riskFactor: json["riskFactor"],
        risk: mapRisk(json["riskFactor"]),
        moneyInvestedDetails: json["moneyInvestedDetails"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "userId": userId,
        "email": email,
        "isVerified": isVerified?.toJson(),
        "hasActiveTransaction": hasActiveTransaction,
        "riskFactor": riskFactor,
        "moneyInvestedDetails": moneyInvestedDetails,
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
