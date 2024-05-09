part of 'borrow_history_bloc.dart';

@immutable
sealed class BorrowHistoryEvent extends Equatable {
  const BorrowHistoryEvent();

  @override
  List<Object> get props => [];
}

class BorrowHistoryEventLoadHistory extends BorrowHistoryEvent {}

class BorrowHistoryEventResetHistory extends BorrowHistoryEvent {}
