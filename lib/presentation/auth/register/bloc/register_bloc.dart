import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:kitakesana/data/models/request/auth/register_request_model.dart';
import 'package:kitakesana/data/repositories/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final model = RegisterRequestModel(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      final message = await authRepository.register(model);
      emit(RegisterSuccess(message: message));
    } catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }
}
