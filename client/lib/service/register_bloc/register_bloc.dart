import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:udharo/data/repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc(this._authRepository) : super(RegisterStateInitial()) {
    on<RegiserEventMakeRegistration>(
      (event, emit) async {
        emit (RegisterStateLoading());
        try {
          final message = await _authRepository.signUp(
            fullName: event.name,
            email: event.email,
            occupation: event.occupation,
            password: event.password,
            phoneNumber: event.phoneNumber,
          );
          if (message == 'SignUp Success') {
            emit(RegisterStateSuccessSigningUp(email: event.email));
          } else {
            emit(RegisterStateError(message: message));
          }
        } catch (e) {
          emit(RegisterStateError(message: e.toString()));
        }
      },
    );
    on<RegisterEventSendEmailVerification>(
      (event, emit) async {
        emit (RegisterStateLoading());
        
        try {
          final message = await _authRepository.sendEmailVerification(
            event.email,
          );
          if (message == 'Verification Sent Successfully') {
            emit(RegisterStateSuccessSendingVerificationEmail());
          } else {
            emit(RegisterStateError(message: message));
          }
        } catch (e) {
          emit(RegisterStateError(message: e.toString()));
        }
      },
    );
  }
}
