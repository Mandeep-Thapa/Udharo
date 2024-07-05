import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:udharo/data/repository/kyc_repository.dart';

part 'upload_kyc_event.dart';
part 'upload_kyc_state.dart';

class UploadKycBloc extends Bloc<UploadKycEvent, UploadKycState> {
  final KYCRepository _kycRepository;
  UploadKycBloc(this._kycRepository) : super(UploadKycStateInitial()) {
    on<UploadKycEventSubmitKYC>((event, emit) async {
      try {
        emit(UploadKycStateLoading());

        final response = await _kycRepository.uploadKYC(
          firstName: event.firstName,
          lastName: event.lastName,
          phoneNumber: event.phoneNumber,
          gender: event.gender,
          citizenshipNumber: event.citizenshipNumber,
          citizenshipFrontPhoto: event.citizenshipFrontPhoto,
          citizenshipBackPhoto: event.citizenshipBackPhoto,
          passportSizePhoto: event.passportSizePhoto,
          panNumber: event.panNumber,
        );
        if (response == 'success') {
          emit(UploadKycStateSuccess());
          return;
        } else {
          emit(UploadKycStateError(response.toString()));
          return;
        }
      } on Exception catch (e) {
        emit(UploadKycStateError(e.toString()));
      }
    });
  }
}
