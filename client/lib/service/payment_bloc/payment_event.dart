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
  final String pidx;

  const PaymentEventVerifyKhaltiTransaction({required this.pidx});

  @override
  List<Object> get props => [pidx];
}

class PaymentEventResetPayment extends PaymentEvent {}
