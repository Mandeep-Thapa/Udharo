part of 'return_money_bloc.dart';

@immutable
sealed class ReturnMoneyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ReturnMoneyEventMakeReturnRequest extends ReturnMoneyEvent {
  final String borrowId;
  final int amount;

  ReturnMoneyEventMakeReturnRequest({
    required this.borrowId,
    required this.amount,
  });

  @override
  List<Object> get props => [borrowId, amount];
}

class ReturnMoneyEventVerifyKhaltiTransaction extends ReturnMoneyEvent {
  final String token;
  final int amount;

  ReturnMoneyEventVerifyKhaltiTransaction({
    required this.token,
    required this.amount,
  });

  @override
  List<Object> get props => [token];
}

class ReturnMoneyEventMakeKhaltiPayment extends ReturnMoneyEvent {
  final BuildContext context;
  final int amount;
  final String productIdentity;
  final String productName;

  ReturnMoneyEventMakeKhaltiPayment({
    required this.context,
    required this.amount,
    required this.productIdentity,
    required this.productName,
  });

  @override
  List<Object> get props => [
        context,
        amount,
        productIdentity,
        productName,
      ];
}


class ReturnMoneyEventSaveKhaltiTransaction extends ReturnMoneyEvent {
  final String idx;
  final int amount;
  final String createdOn;
  final String senderName;
  final String receiverName;
  final int feeAmount;

   ReturnMoneyEventSaveKhaltiTransaction({
    required this.idx,
    required this.amount,
    required this.senderName,
    required this.createdOn,
    required this.receiverName,
    required this.feeAmount,
  });

  @override
  List<Object> get props => [idx];
}
