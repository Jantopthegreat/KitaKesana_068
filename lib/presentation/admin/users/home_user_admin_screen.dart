import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/data/models/response/admin/users/user_admin_response_model.dart';
import 'package:kitakesana/data/repositories/admin/admin_user_repository.dart';
import 'package:kitakesana/presentation/admin/bloc/user/admin_user_bloc.dart';
import 'package:kitakesana/services/admin_user_service.dart';

class HomeUserAdminScreen extends StatelessWidget {
  const HomeUserAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AdminUserBloc(userService: AdminUserService(AdminUserRepository()))
            ..add(LoadAdminUsersEvent()),
      child: const _HomeUserAdminView(),
    );
  }
}

class _HomeUserAdminView extends StatelessWidget {
  const _HomeUserAdminView();

  void _confirmDelete(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pengguna'),
        content: const Text('Yakin ingin menghapus pengguna ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AdminUserBloc>().add(DeleteAdminUserEvent(userId));
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(BuildContext context, UserAdminResponseModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text('Review: ${user.totalReviews}'),
            Text(
              'Terdaftar: ${user.createdAt.toLocal().toString().split(' ')[0]}',
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(context, user.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pengguna'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocConsumer<AdminUserBloc, AdminUserState>(
        listener: (context, state) {
          if (state is AdminUserError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AdminUserSuccessMessage) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AdminUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminUserLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text('Belum ada pengguna.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                return _buildUserItem(context, state.users[index]);
              },
            );
          } else if (state is AdminUserError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
