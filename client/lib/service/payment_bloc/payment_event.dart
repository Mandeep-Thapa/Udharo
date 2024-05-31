part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentEventMakeKhaltiPayment extends PaymentEvent {
  final BuildContext context;
  final int amount;
  final String productIdentity;
  final String productName;

  const PaymentEventMakeKhaltiPayment({
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

class PaymentEventAcceptBorrowRequest extends PaymentEvent {
  final String productIdentity;

  const PaymentEventAcceptBorrowRequest({required this.productIdentity});

  @override
  List<Object> get props => [productIdentity];
}

class PaymentEventVerifyKhaltiTransaction extends PaymentEvent {
  final String token;
  final int amount;

  const PaymentEventVerifyKhaltiTransaction({
    required this.token,
    required this.amount,
  });

  @override
  List<Object> get props => [token];
}

class PaymentEventSaveKhaltiTransaction extends PaymentEvent {
  final String idx;
  final int amount;
  final String createdOn;
  final String senderName;
  final String receiverName;
  final int feeAmount;

  const PaymentEventSaveKhaltiTransaction({
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

// class PaymentEventResetPayment extends PaymentEvent {}
