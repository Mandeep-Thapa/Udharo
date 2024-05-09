import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:udharo/data/repository/borrow_repository.dart';

part 'khalti_payment_event.dart';
part 'khalti_payment_state.dart';

class KhaltiPaymentBloc extends Bloc<KhaltiPaymentEvent, KhaltiPaymentState> {
  final BorrowRepository _borrowRepository;
  KhaltiPaymentBloc(this._borrowRepository)
      : super(KhaltiPaymentStateInitial()) {
    on<KhaltiPaymentEventMakePayment>((event, emit) async {
      try {
        // make payment
        await KhaltiScope.of(event.context).pay(
          config: PaymentConfig(
            // amount: event.amount * 100,

            // for testing
            amount: 20 * 100,

            productIdentity: event.productIdentity,
            productName: event.productName,
          ),
          preferences: [
            PaymentPreference.khalti,
          ],
          onSuccess: (success) async {
            // print('Success: ${success.token}');
            try {
              emit(KhaltiPaymentStateInitial());
              await _borrowRepository
                  .acceptBorrowRequest(event.productIdentity);
              emit(KhaltiPaymentStateSuccess(success: success));
            } on Exception catch (e) {
              emit(KhaltiPaymentStateError(e.toString()));
            }
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
