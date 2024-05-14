part of 'view_kyc_bloc.dart';

@immutable
sealed class ViewKycState {}

final class ViewKycStateInitial extends ViewKycState {}

final class Loaded extends ViewKycState {}

final class ViewKycStateError extends ViewKycState {
  final String message;

  ViewKycStateError(this.message);
}
