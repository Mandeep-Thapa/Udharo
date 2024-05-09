import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:udharo/data/repository/borrow_repository.dart';

part 'create_borrow_request_event.dart';
part 'create_borrow_request_state.dart';

class CreateBorrowRequestBloc
    extends Bloc<CreateBorrowRequestEvent, CreateBorrowRequestState> {
  final BorrowRepository _borrowRepository;
  CreateBorrowRequestBloc(this._borrowRepository)
      : super(CreateBorrowRequestStateInitial()) {
    on<CreateBorrowRequestEventSubmitRequest>(
      (event, emit) async {
        try {
          // call the repository function to create borrow request
          await _borrowRepository.createBorrowRequest(
            amount: event.amount,
            purpose: event.purpose,
            interestRate: event.interestRate,
            paybackPeriod: event.paybackPeriod,
          );
          emit(CreateBorrowRequestStateSuccess());
        } on Exception catch (e) {
          emit(CreateBorrowRequestStateError(e.toString()));
        }
      },
    );
    on<CreateBorrowRequestEventResetRequest>(
      (event, emit) {
        emit(CreateBorrowRequestStateInitial());
      },
    );
  }
}
