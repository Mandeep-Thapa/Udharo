part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEventSignIn extends LoginEvent {
  final String email;
  final String password;

  const LoginEventSignIn(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
