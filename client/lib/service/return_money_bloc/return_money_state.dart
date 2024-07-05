part of 'return_money_bloc.dart';

@immutable
sealed class ReturnMoneyState {}

final class ReturnMoneyStateInitial extends ReturnMoneyState {}

final class ReturnMoneyStateReturnSuccess extends ReturnMoneyState {}

final class ReturnMoneyStateKhaltiPaymentSuccess extends ReturnMoneyState {
 final PaymentSuccessModel success;

  ReturnMoneyStateKhaltiPaymentSuccess({required this.success});

}

final class ReturnMoneyStateKhaltiVerificationSuccess extends ReturnMoneyState {
  final KhaltiVerificationSuccessModel success;

  ReturnMoneyStateKhaltiVerificationSuccess({required this.success});

}

final class ReturnMoneyStateError extends ReturnMoneyState {
  final String message;

  ReturnMoneyStateError(this.message);
}
