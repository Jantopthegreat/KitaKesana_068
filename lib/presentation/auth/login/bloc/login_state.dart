part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginResponseModel responseModel;

  LoginSuccess(this.responseModel);
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}
