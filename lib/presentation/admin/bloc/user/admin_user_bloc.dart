import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/data/models/response/admin/users/user_admin_response_model.dart';
import 'package:kitakesana/services/admin_user_service.dart';

part 'admin_user_event.dart';
part 'admin_user_state.dart';

class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final AdminUserService userService;

  AdminUserBloc({required this.userService}) : super(AdminUserInitial()) {
    // 🔹 Load user list
    on<LoadAdminUsersEvent>((event, emit) async {
      emit(AdminUserLoading());
      try {
        final users = await userService.fetchAllUsers();
        emit(AdminUserLoaded(users));
      } catch (e) {
        emit(AdminUserError('Gagal memuat data user: ${e.toString()}'));
      }
    });

    // 🔹 Delete user
    on<DeleteAdminUserEvent>((event, emit) async {
      emit(AdminUserLoading());
      try {
        await userService.deleteUser(event.userId);
        final users = await userService.fetchAllUsers(); // Refresh
        emit(AdminUserLoaded(users));
      } catch (e) {
        emit(AdminUserError('Gagal menghapus user: ${e.toString()}'));
      }
    });
  }
}
