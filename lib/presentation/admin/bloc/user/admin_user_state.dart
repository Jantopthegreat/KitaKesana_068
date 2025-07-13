part of 'admin_user_bloc.dart';

abstract class AdminUserState {}

class AdminUserInitial extends AdminUserState {}

class AdminUserLoading extends AdminUserState {}

class AdminUserLoaded extends AdminUserState {
  final List<UserAdminResponseModel> users;
  AdminUserLoaded(this.users);
}

class AdminUserError extends AdminUserState {
  final String message;
  AdminUserError(this.message);
}

class AdminUserDeleted extends AdminUserState {
  final int userId;
  AdminUserDeleted(this.userId);
}

class AdminUserSuccessMessage extends AdminUserState {
  final String message;
  AdminUserSuccessMessage(this.message);
}
