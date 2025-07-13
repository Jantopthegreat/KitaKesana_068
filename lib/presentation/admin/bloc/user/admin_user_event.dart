part of 'admin_user_bloc.dart';

abstract class AdminUserEvent {}

class LoadAdminUsersEvent extends AdminUserEvent {}

class DeleteAdminUserEvent extends AdminUserEvent {
  final int userId;
  DeleteAdminUserEvent(this.userId);
}
