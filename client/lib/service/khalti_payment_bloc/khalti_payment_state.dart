part of 'khalti_payment_bloc.dart';

@immutable
sealed class KhaltiPaymentState {}

final class KhaltiPaymentStateInitial extends KhaltiPaymentState {}

final class KhaltiPaymentStateSuccess extends KhaltiPaymentState {
  final PaymentSuccessModel success;

  KhaltiPaymentStateSuccess({required this.success});
}

final class KhaltiPaymentStateError extends KhaltiPaymentState {
  final String message;

  KhaltiPaymentStateError(this.message);
}
