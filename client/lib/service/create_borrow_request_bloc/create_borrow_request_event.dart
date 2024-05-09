part of 'create_borrow_request_bloc.dart';

@immutable
sealed class CreateBorrowRequestEvent extends Equatable {
  const CreateBorrowRequestEvent();

  @override
  List<Object> get props => [];
}

class CreateBorrowRequestEventSubmitRequest extends CreateBorrowRequestEvent {
  final int amount;
  final String purpose;
  final double interestRate;
  final int paybackPeriod;

  const CreateBorrowRequestEventSubmitRequest({
    required this.amount,
    required this.purpose,
    required this.interestRate,
    required this.paybackPeriod,
  });

  @override
  List<Object> get props => [
        amount,
        purpose,
        interestRate,
        paybackPeriod,
      ];
}

class CreateBorrowRequestEventResetRequest extends CreateBorrowRequestEvent {}
