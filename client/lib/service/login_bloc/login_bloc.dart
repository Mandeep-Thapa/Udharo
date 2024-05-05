import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udharo/data/repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  LoginBloc(this._authRepository) : super(LoginStateInitial()) {
    on<LoginEventSignIn>((event, emit) async {
      try {
        final message =
            await _authRepository.signIn(event.email, event.password);
        if (message == 'Login Success') {
          emit(LoginStateSuccess());
        } else {
          emit(LoginStateError(message));
        }
      } catch (e) {
        emit(LoginStateError(e.toString()));
      }
    });
  }
}
