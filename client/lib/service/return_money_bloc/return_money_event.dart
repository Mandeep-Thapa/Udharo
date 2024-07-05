part of 'return_money_bloc.dart';

@immutable
sealed class ReturnMoneyEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class ReturnMoneyEventMakeReturnRequest extends ReturnMoneyEvent{
  final String borrowId;
  final double amount;

  ReturnMoneyEventMakeReturnRequest({
    required this.borrowId,
    required this.amount,
  });

  @override
  List<Object> get props => [borrowId, amount];
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

