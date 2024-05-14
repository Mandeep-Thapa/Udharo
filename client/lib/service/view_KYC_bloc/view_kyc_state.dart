part of 'view_kyc_bloc.dart';

@immutable
sealed class ViewKycState {}

final class ViewKycStateInitial extends ViewKycState {}

final class ViewKycStateLoaded extends ViewKycState {
  final ViewKycModel kyc;

  ViewKycStateLoaded({required this.kyc});
}

final class ViewKycStateError extends ViewKycState {
  final String message;

  ViewKycStateError(this.message);
}
