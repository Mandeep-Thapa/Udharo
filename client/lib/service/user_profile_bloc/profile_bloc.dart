import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:udharo/data/model/user_profile_model.dart';
import 'package:udharo/data/repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  ProfileBloc(this._userRepository) : super(ProfileStateInitial()) {
    on<ProfileEventLoadProfile>((event, emit) async {
      try {
        final user = await _userRepository.fetchUserProfile();
        emit(ProfileStateLoaded(user: user));
      } on Exception catch (e) {
        emit(ProfileStateError(e.toString()));
      }
    });
    on<ProfileEventResetProfile>((event, emit) {
      emit(ProfileStateInitial());
    });
  }
}
