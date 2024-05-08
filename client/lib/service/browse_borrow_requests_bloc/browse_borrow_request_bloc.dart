import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:udharo/data/model/browse_borrow_model.dart';
import 'package:udharo/data/repository/borrow_repository.dart';

part 'browse_borrow_request_event.dart';
part 'browse_borrow_request_state.dart';

class BrowseBorrowRequestBloc
    extends Bloc<BrowseBorrowRequestEvent, BrowseBorrowRequestState> {
  final BorrowRepository _borrowRepository;

  BrowseBorrowRequestBloc(this._borrowRepository)
      : super(BrowseBorrowRequestStateInitial()) {
    on<BrowseBorrowRequestEventLoadRequests>((event, emit) async {
      try {
        final borrowRequests = await _borrowRepository.fetchBorrowRequest();
        emit(BrowseBorrowRequestStateLoaded(borrowRequests: borrowRequests));
      } on Exception catch (e) {
        emit(BrowseBorrowRequestStateError(e.toString()));
      }
    });
  }
}
