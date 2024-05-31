part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentStateInitial extends PaymentState {}


// final class PaymentStateLoading extends PaymentState {}


final class PaymentStateKhaltiPaymentSuccess extends PaymentState {
  final PaymentSuccessModel success;

  PaymentStateKhaltiPaymentSuccess({required this.success});
}

final class PaymentStateKhaltiPaymentVerificationSuccess extends PaymentState {
  final KhaltiVerificationSuccessModel success;

  PaymentStateKhaltiPaymentVerificationSuccess({required this.success});
}


final class PaymentStateKhaltiPaymentSaveKhaltiPaymentSuccess extends PaymentState {}


final class PaymentStateAcceptSuccess extends PaymentState {
  final int amount;
  final String borrowId;

  PaymentStateAcceptSuccess({required this.amount, required this.borrowId,});
}

final class PaymentStateError extends PaymentState {
  final String message;

  PaymentStateError(this.message);
}
