part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentStateInitial extends PaymentState {}

final class PaymentStateKhaltiPaymentSuccess extends PaymentState {
  final PaymentSuccessModel success;

  PaymentStateKhaltiPaymentSuccess({required this.success});
}

final class PaymentStateAcceptSuccess extends PaymentState {}

final class PaymentStateError extends PaymentState {
  final String message;

  PaymentStateError(this.message);
}
