part of 'upload_kyc_bloc.dart';

@immutable
sealed class UploadKycEvent extends Equatable {
  const UploadKycEvent();

  @override
  List<Object> get props => [];
}

class UploadKycEventSubmitKYC extends UploadKycEvent {
  final String firstName;
  final String lastName;
  final String gender;
  final String citizenshipNumber;
  final String? panNumber;
  final File citizenshipFrontPhoto;
  final File citizenshipBackPhoto;
  final File passportSizePhoto;

  const UploadKycEventSubmitKYC({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.citizenshipNumber,
    required this.panNumber,
    required this.citizenshipFrontPhoto,
    required this.citizenshipBackPhoto,
    required this.passportSizePhoto,
  });
}
