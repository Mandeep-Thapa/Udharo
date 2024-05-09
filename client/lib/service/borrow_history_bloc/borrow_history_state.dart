part of 'borrow_history_bloc.dart';

@immutable
sealed class BorrowHistoryState {}

final class BorrowHistoryStateInitial extends BorrowHistoryState {}

final class BorrowHistoryStateLoaded extends BorrowHistoryState {
  final List<BorrowHistoryModel> borrowHistory;

  BorrowHistoryStateLoaded({required this.borrowHistory});
}

final class BorrowHistoryStateError extends BorrowHistoryState {
  final String message;

  BorrowHistoryStateError({required this.message});
}
