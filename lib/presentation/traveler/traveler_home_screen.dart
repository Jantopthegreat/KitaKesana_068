import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/presentation/places/bloc/place_bloc.dart';
import 'package:kitakesana/data/models/response/place/place_response_model.dart';
import 'package:kitakesana/services/place_service.dart';
import 'package:kitakesana/data/repositories/place_repository.dart';
import 'package:kitakesana/presentation/location/location_picker_screen.dart';
import 'package:kitakesana/presentation/traveler/wisata/traveler_wisata_screen.dart';
import 'package:kitakesana/presentation/traveler/wisata/traveler_wisata_detail_screen.dart';
import 'package:kitakesana/presentation/places/bloc/place_detail_bloc.dart';

class HomeTravelerScreen extends StatefulWidget {
  const HomeTravelerScreen({super.key});

  @override
  State<HomeTravelerScreen> createState() => _HomeTravelerScreenState();
}

class _HomeTravelerScreenState extends State<HomeTravelerScreen> {
  late PlaceBloc _placeBloc;
  String? selectedKabupaten;
  final String selectedCategory = 'Wisata';
  @override
  void initState() {
    super.initState();
    _placeBloc = PlaceBloc(placeService: PlaceService(PlaceRepository()));
    _placeBloc.add(
      FetchPlacesEvent(category: selectedCategory),
    ); // awal tanpa lokasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        toolbarHeight: 140,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/default_avatar.png'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Halo, Traveler',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            InkWell(
              onTap: () async {
                final kabupaten = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LocationPickerScreen(),
                  ),
                );
                if (kabupaten != null) {
                  setState(() {
                    selectedKabupaten = kabupaten;
                  });
                  _placeBloc.add(
                    FetchPlacesEvent(
                      kabupaten: kabupaten,
                      category: selectedCategory,
                    ),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    selectedKabupaten != null
                        ? selectedKabupaten!
                        : 'Pilih Lokasi Anda',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kategori',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [buildCategoryIcon(Icons.place, 'Wisata')],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Rekomendasi Tempat Wisata',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              BlocBuilder<PlaceBloc, PlaceState>(
                bloc: _placeBloc,
                builder: (context, state) {
                  if (state is PlaceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PlaceLoaded) {
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.places.length,
                        itemBuilder: (context, index) {
                          final place = state.places[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) =>
                                        PlaceDetailBloc(
                                          placeService: PlaceService(
                                            PlaceRepository(),
                                          ),
                                        )..add(
                                          FetchPlaceDetailEvent(place.id),
                                        ), // <-- ini penting
                                    child: TravelerDetailWisataScreen(
                                      placeId: place.id,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: buildPlaceCard(place),
                          );
                        },
                      ),
                    );
                  } else if (state is PlaceError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TravelerWisataScreen(
              initialKabupaten: selectedKabupaten,
              category: label,
            ),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 24, color: Colors.deepPurple),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceCard(PlaceResponseModel place) {
    return Container(
      width: 160,
      height: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'http://10.0.2.2:3000${place.photoUrl}',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.image_not_supported, size: 40),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      place.rating.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 4,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
