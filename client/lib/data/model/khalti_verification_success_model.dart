

import 'dart:convert';

KhaltiVerificationSuccessModel khaltiVerificationSuccessModelFromJson(String str) => KhaltiVerificationSuccessModel.fromJson(json.decode(str));

String khaltiVerificationSuccessModelToJson(KhaltiVerificationSuccessModel data) => json.encode(data.toJson());

class KhaltiVerificationSuccessModel {
    final String? status;
    final String? message;
    final Data? data;

    KhaltiVerificationSuccessModel({
        this.status,
        this.message,
        this.data,
    });

    factory KhaltiVerificationSuccessModel.fromJson(Map<String, dynamic> json) => KhaltiVerificationSuccessModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final String? idx;
    final Type? type;
    final State? state;
    final int? amount;
    final int? feeAmount;
    final dynamic reference;
    final bool? refunded;
    final DateTime? createdOn;
    final Type? user;
    final Merchant? merchant;
    final dynamic remarks;
    final String? token;
    final int? cashback;
    final String? productIdentity;

    Data({
        this.idx,
        this.type,
        this.state,
        this.amount,
        this.feeAmount,
        this.reference,
        this.refunded,
        this.createdOn,
        this.user,
        this.merchant,
        this.remarks,
        this.token,
        this.cashback,
        this.productIdentity,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        idx: json["idx"],
        type: json["type"] == null ? null : Type.fromJson(json["type"]),
        state: json["state"] == null ? null : State.fromJson(json["state"]),
        amount: json["amount"],
        feeAmount: json["fee_amount"],
        reference: json["reference"],
        refunded: json["refunded"],
        createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
        user: json["user"] == null ? null : Type.fromJson(json["user"]),
        merchant: json["merchant"] == null ? null : Merchant.fromJson(json["merchant"]),
        remarks: json["remarks"],
        token: json["token"],
        cashback: json["cashback"],
        productIdentity: json["product_identity"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "type": type?.toJson(),
        "state": state?.toJson(),
        "amount": amount,
        "fee_amount": feeAmount,
        "reference": reference,
        "refunded": refunded,
        "created_on": createdOn?.toIso8601String(),
        "user": user?.toJson(),
        "merchant": merchant?.toJson(),
        "remarks": remarks,
        "token": token,
        "cashback": cashback,
        "product_identity": productIdentity,
    };
}

class Merchant {
    final String? idx;
    final String? name;
    final String? mobile;
    final String? email;

    Merchant({
        this.idx,
        this.name,
        this.mobile,
        this.email,
    });

    factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        idx: json["idx"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "mobile": mobile,
        "email": email,
    };
}

class State {
    final String? idx;
    final String? name;
    final String? template;

    State({
        this.idx,
        this.name,
        this.template,
    });

    factory State.fromJson(Map<String, dynamic> json) => State(
        idx: json["idx"],
        name: json["name"],
        template: json["template"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "template": template,
    };
}

class Type {
    final String? idx;
    final String? name;

    Type({
        this.idx,
        this.name,
    });

    factory Type.fromJson(Map<String, dynamic> json) => Type(
        idx: json["idx"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
    };
}
