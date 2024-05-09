part of 'khalti_payment_bloc.dart';

@immutable
sealed class KhaltiPaymentEvent extends Equatable {
  const KhaltiPaymentEvent();

  @override
  List<Object> get props => [];
}

class KhaltiPaymentEventMakePayment extends KhaltiPaymentEvent {
  final BuildContext context;
  final int amount;
  final String productIdentity;
  final String productName;

  const KhaltiPaymentEventMakePayment({
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
