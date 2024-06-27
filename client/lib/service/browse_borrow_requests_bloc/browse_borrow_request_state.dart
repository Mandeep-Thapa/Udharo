part of 'browse_borrow_request_bloc.dart';

@immutable
sealed class BrowseBorrowRequestState {}

final class BrowseBorrowRequestStateInitial extends BrowseBorrowRequestState {}

final class BrowseBorrowRequestStateLoaded extends BrowseBorrowRequestState {
  final BrowseBorrowRequestModel borrowRequests;
  final UserProfileModel user;

  BrowseBorrowRequestStateLoaded({
    required this.borrowRequests,
    required this.user,
  });
}

final class BrowseBorrowRequestStateError extends BrowseBorrowRequestState {
  final String message;

  BrowseBorrowRequestStateError(this.message);
}
