import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:udharo/data/model/borrow_history_model.dart';
import 'package:udharo/data/repository/borrow_repository.dart';

part 'borrow_history_event.dart';
part 'borrow_history_state.dart';

class BorrowHistoryBloc extends Bloc<BorrowHistoryEvent, BorrowHistoryState> {
  final BorrowRepository _borrowRepository;

  BorrowHistoryBloc(this._borrowRepository)
      : super(BorrowHistoryStateInitial()) {
    on<BorrowHistoryEventLoadHistory>(
      (event, emit) async {
        try {
          final borrowHistory = await _borrowRepository.fetchBorrowHistory();
          emit(BorrowHistoryStateLoaded(borrowHistory: borrowHistory));
        } on Exception catch (e) {
          emit(BorrowHistoryStateError(message: e.toString()));
        }
      },
    );
    on<BorrowHistoryEventResetHistory>(
      (event, emit) {
        emit(BorrowHistoryStateInitial());
      },
    );
  }
}
