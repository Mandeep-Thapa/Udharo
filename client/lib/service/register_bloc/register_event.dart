part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegiserEventMakeRegistration extends RegisterEvent {
  final String name;
  final String email;
  final String occupation;
  final String password;

  const RegiserEventMakeRegistration({
    required this.name,
    required this.email,
    required this.password,
    required this.occupation,
  });
}
