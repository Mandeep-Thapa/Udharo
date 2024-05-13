part of 'upload_kyc_bloc.dart';

@immutable
sealed class UploadKycState {}

final class UploadKycStateInitial extends UploadKycState {}

final class UploadKycStateSuccess extends UploadKycState {}

final class UploadKycStateError extends UploadKycState {
  final String message;

  UploadKycStateError(this.message);
}
