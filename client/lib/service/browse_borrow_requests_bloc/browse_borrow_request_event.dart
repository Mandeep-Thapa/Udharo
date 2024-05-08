part of 'browse_borrow_request_bloc.dart';

@immutable
sealed class BrowseBorrowRequestEvent extends Equatable {
  const BrowseBorrowRequestEvent();

  @override
  List<Object> get props => [];
}

class BrowseBorrowRequestEventLoadRequests extends BrowseBorrowRequestEvent {}
