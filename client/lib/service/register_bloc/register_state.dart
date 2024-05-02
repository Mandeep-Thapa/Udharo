part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterStateInitial extends RegisterState {}

final class RegisterStateError extends RegisterState {
  final String message;

  RegisterStateError({
    required this.message,
  });
}
