part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginRequested extends LoginEvent {
  final LoginRequestModel model;

  LoginRequested(this.model);
}
