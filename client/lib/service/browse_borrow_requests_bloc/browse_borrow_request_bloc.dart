import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:udharo/data/model/browse_borrow_model.dart';
import 'package:udharo/data/model/user_profile_model.dart';
import 'package:udharo/data/repository/borrow_repository.dart';
import 'package:udharo/data/repository/user_repository.dart';

part 'browse_borrow_request_event.dart';
part 'browse_borrow_request_state.dart';

class BrowseBorrowRequestBloc
    extends Bloc<BrowseBorrowRequestEvent, BrowseBorrowRequestState> {
  final BorrowRepository _borrowRepository;
  final UserRepository _userRepository;

  BrowseBorrowRequestBloc(this._borrowRepository, this._userRepository)
      : super(BrowseBorrowRequestStateInitial()) {
    on<BrowseBorrowRequestEventLoadRequests>(
      (event, emit) async {
        try {
          final borrowRequests = await _borrowRepository.fetchBorrowRequest();
          try {
            final user = await _userRepository.fetchUserProfile();
            emit(BrowseBorrowRequestStateLoaded(
              borrowRequests: borrowRequests,
              user: user,
            ));
          } on Exception catch (e) {
            emit(BrowseBorrowRequestStateError(e.toString()));
          }
        } on Exception catch (e) {
          emit(BrowseBorrowRequestStateError(e.toString()));
        }
      },
    );
    on<BrowseBorrowRequestEventResetRequests>(
      (event, emit) {
        emit(BrowseBorrowRequestStateInitial());
      },
    );
  }
}
