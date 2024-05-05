part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginStateInitial extends LoginState {}

final class LoginStateSuccess extends LoginState {}

final class LoginStateError extends LoginState {
  final String message;

  const LoginStateError(this.message);

  @override
  List<Object> get props => [message];
}
