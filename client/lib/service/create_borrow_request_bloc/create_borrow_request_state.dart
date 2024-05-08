part of 'create_borrow_request_bloc.dart';

@immutable
sealed class CreateBorrowRequestState {}

final class CreateBorrowRequestStateInitial extends CreateBorrowRequestState {}

final class CreateBorrowRequestStateSuccess extends CreateBorrowRequestState {}

final class CreateBorrowRequestStateError extends CreateBorrowRequestState {
  final String message;

  CreateBorrowRequestStateError(this.message);
}
