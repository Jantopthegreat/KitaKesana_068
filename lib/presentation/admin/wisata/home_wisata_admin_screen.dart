import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/data/models/response/admin/place/place_admin_response_model.dart';
import 'package:kitakesana/presentation/admin/wisata/add_wisata_admin_screen.dart';
import 'package:kitakesana/presentation/admin/wisata/detail_wisata_admin_screen.dart';
import 'package:kitakesana/presentation/admin/wisata/edit_wisata_admin_screen.dart';
import 'package:kitakesana/presentation/admin/bloc/place/admin_place_bloc.dart';
import 'package:kitakesana/services/admin_place_service.dart';
import 'package:kitakesana/data/repositories/admin/admin_place_repository.dart';

class HomeWisataAdminScreen extends StatelessWidget {
  const HomeWisataAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminPlaceBloc(
        placeService: AdminPlaceService(AdminPlaceRepository()),
      )..add(FetchAdminPlacesEvent()),
      child: const _HomeWisataAdminView(),
    );
  }
}

class _HomeWisataAdminView extends StatelessWidget {
  const _HomeWisataAdminView({super.key});

  void _showDeleteConfirmation(BuildContext context, int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Tempat'),
        content: const Text('Yakin ingin menghapus tempat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      context.read<AdminPlaceBloc>().add(DeleteAdminPlaceEvent(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Tempat Wisata'),
        backgroundColor: Colors.blue,
      ),
      body: BlocConsumer<AdminPlaceBloc, AdminPlaceState>(
        listener: (context, state) {
          if (state is AdminPlaceDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tempat berhasil dihapus')),
            );
            context.read<AdminPlaceBloc>().add(FetchAdminPlacesEvent());
          } else if (state is AdminPlaceError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AdminPlaceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminPlaceLoaded) {
            final List<PlaceAdminResponseModel> places = state.places;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AdminPlaceBloc>().add(FetchAdminPlacesEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(place.kabupaten),
                          const SizedBox(height: 4),
                          Text('Rating: ${place.rating}'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DetailPlaceScreen(placeId: place.id),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.info,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<AdminPlaceBloc>(),
                                        child: EditPlaceScreen(
                                          placeId: place.id,
                                        ),
                                      ),
                                    ),
                                  ).then((_) {
                                    context.read<AdminPlaceBloc>().add(
                                      FetchAdminPlacesEvent(),
                                    );
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _showDeleteConfirmation(context, place.id),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is AdminPlaceError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox(); // State initial atau kosong
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AdminPlaceBloc>(),
                child: const AddPlaceScreen(),
              ),
            ),
          ).then((_) {
            context.read<AdminPlaceBloc>().add(FetchAdminPlacesEvent());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
