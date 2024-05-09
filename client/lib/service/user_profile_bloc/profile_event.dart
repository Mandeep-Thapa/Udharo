part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileEventLoadProfile extends ProfileEvent {
  const ProfileEventLoadProfile();
}

class ProfileEventResetProfile extends ProfileEvent {}
