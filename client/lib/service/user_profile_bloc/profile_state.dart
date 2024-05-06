part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileStateInitial extends ProfileState {}

final class ProfileStateLoaded extends ProfileState {
  final UserProfileModel user;

  ProfileStateLoaded({required this.user});
}

final class ProfileStateError extends ProfileState {
  final String message;

  ProfileStateError(this.message);
}
