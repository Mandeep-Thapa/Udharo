import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

part 'khalti_payment_event.dart';
part 'khalti_payment_state.dart';

class KhaltiPaymentBloc extends Bloc<KhaltiPaymentEvent, KhaltiPaymentState> {
  KhaltiPaymentBloc() : super(KhaltiPaymentStateInitial()) {
    on<KhaltiPaymentEventMakePayment>((event, emit) async {
      try {
        // make payment
        await KhaltiScope.of(event.context).pay(
          config: PaymentConfig(
            amount: event.amount * 100,

            // for testing
            // amount: 20 * 100,

            productIdentity: event.productIdentity,
            productName: event.productName,
          ),
          preferences: [
            PaymentPreference.khalti,
          ],
          onSuccess: (success) {
            // print('Success: ${success.token}');
            emit(KhaltiPaymentStateSuccess(success: success));
          },
          onFailure: (failure) {
            emit(KhaltiPaymentStateError(failure.message));
          },
        );
      } on Exception catch (e) {
        emit(KhaltiPaymentStateError(e.toString()));
      }
    });
  }
}
