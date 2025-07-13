import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:kitakesana/data/models/request/auth/login_request_model.dart';
import 'package:kitakesana/data/repositories/auth_repository.dart';
import 'package:kitakesana/data/models/response/auth/login_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await authRepository.login(event.model);
        emit(LoginSuccess(user!));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
