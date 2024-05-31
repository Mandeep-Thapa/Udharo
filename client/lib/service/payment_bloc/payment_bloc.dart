import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:udharo/data/model/khalti_verification_success_model.dart';
import 'package:udharo/data/repository/borrow_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final BorrowRepository _borrowRepository;
  PaymentBloc(this._borrowRepository) : super(PaymentStateInitial()) {
    // make khalti payment
    on<PaymentEventMakeKhaltiPayment>(
      (event, emit) async {
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
              emit(PaymentStateKhaltiPaymentSuccess(success: success));
              // print('Success: ${success.token}');
            },
            onFailure: (failure) {
              emit(PaymentStateError(failure.message));
            },
          );
        } on Exception catch (e) {
          emit(PaymentStateError(e.toString()));
        }
      },
    );
    // accept borrow request
    on<PaymentEventAcceptBorrowRequest>(
      (event, emit) async {
        try {
          await _borrowRepository.acceptBorrowRequest(event.productIdentity);
          emit(PaymentStateAcceptSuccess());
        } on Exception catch (e) {
          emit(PaymentStateError(e.toString()));
        }
      },
    );
    // verify khalti transaction
    on<PaymentEventVerifyKhaltiTransaction>(
      (event, emit) async {
        try {
          final verificationMessage =
              await _borrowRepository.verifyKhaltiTransaction(
            token: event.token,
            amount: event.amount,
          );

          print('Verification message: ${verificationMessage.data?.amount}');
          emit(PaymentStateKhaltiPaymentVerificationSuccess(
              success: verificationMessage));
        } on Exception catch (e) {
          emit(PaymentStateError(e.toString()));
        }
      },
    );
    // save khalti transaction
    on<PaymentEventSaveKhaltiTransaction>(
      (event, emit) async {
        try {
          await _borrowRepository.saveKhaltiTransaction(
            idx: event.idx,
            amount: event.amount,
            sendername: event.senderName,
            receiverName: event.receiverName,
            createdOn: event.createdOn,
            feeAmount: event.feeAmount,
          );
          emit(PaymentStateKhaltiPaymentSaveKhaltiPaymentSuccess());
        } on Exception catch (e) {
          emit(PaymentStateError(e.toString()));
        }
      },
    );
    // reset payment bloc
    // on<PaymentEventResetPayment>(
    //   (event, emit) {
    //     emit(PaymentStateInitial());
    //   },
    // );
  }
}
