import 'package:kitakesana/data/models/response/admin/users/user_admin_response_model.dart';
import 'package:kitakesana/data/repositories/admin/admin_user_repository.dart';

class AdminUserService {
  final AdminUserRepository _repository;

  AdminUserService(this._repository);

  Future<List<UserAdminResponseModel>> fetchAllUsers() async {
    return await _repository.getAllUsers();
  }

  Future<void> deleteUser(int id) async {
    return await _repository.deleteUser(id);
  }
}
