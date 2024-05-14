import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:udharo/data/repository/kyc_repository.dart';

part 'view_kyc_event.dart';
part 'view_kyc_state.dart';

class ViewKycBloc extends Bloc<ViewKycEvent, ViewKycState> {
  final KYCRepository _kycRepository;
  ViewKycBloc(this._kycRepository) : super(ViewKycStateInitial()) {
    on<ViewKycEventLoadKYC>((event, emit) async {
      try {
        _kycRepository.fetchKYC();
      } on Exception catch (e) {
        emit(ViewKycStateError(e.toString()));
      }
    });
  }
}
