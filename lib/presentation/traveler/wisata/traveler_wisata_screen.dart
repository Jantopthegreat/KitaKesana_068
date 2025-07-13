import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kitakesana/data/models/response/place/place_response_model.dart';
import 'package:kitakesana/data/repositories/place_repository.dart';
import 'package:kitakesana/services/place_service.dart';
import 'package:kitakesana/presentation/places/bloc/place_bloc.dart';
import 'package:kitakesana/presentation/location/location_picker_screen.dart';

class TravelerWisataScreen extends StatefulWidget {
  final String? userName;
  final String? initialKabupaten;
  final String? category;

  const TravelerWisataScreen({
    super.key,
    this.userName,
    this.initialKabupaten,
    this.category,
  });

  @override
  State<TravelerWisataScreen> createState() => _TravelerWisataScreenState();
}

class _TravelerWisataScreenState extends State<TravelerWisataScreen> {
  late PlaceBloc _placeBloc;
  String? selectedKabupaten;
  String? selectedCategory;

  final List<String> kabupatenList = [
    'Bantul',
    'Sleman',
    'Kota Yogyakarta',
    'Gunungkidul',
    'Kulon Progo',
  ];

  final List<String> categories = ['Wisata', 'Budaya', 'Kuliner'];

  @override
  void initState() {
    super.initState();
    selectedKabupaten = widget.initialKabupaten;
    selectedCategory = widget.category ?? 'Wisata';

    _placeBloc = PlaceBloc(placeService: PlaceService(PlaceRepository()));
    _placeBloc.add(
      FetchPlacesEvent(
        kabupaten: selectedKabupaten,
        category: selectedCategory,
      ),
    );
  }

  void _onFilterChanged(String category) {
    setState(() => selectedCategory = category);
    _placeBloc.add(
      FetchPlacesEvent(kabupaten: selectedKabupaten, category: category),
    );
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
                final selectedKabupaten = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LocationPickerScreen(),
                  ),
                );
                if (selectedKabupaten != null) {
                  _placeBloc.add(
                    FetchPlacesEvent(kabupaten: selectedKabupaten),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Pilih Lokasi Anda',
                    style: TextStyle(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Lokasi
            DropdownButtonFormField<String>(
              value: selectedKabupaten,
              hint: const Text('Pilih Kabupaten'),
              onChanged: (value) {
                setState(() => selectedKabupaten = value);
                _placeBloc.add(
                  FetchPlacesEvent(
                    kabupaten: value,
                    category: selectedCategory,
                  ),
                );
              },
              items: kabupatenList.map((kab) {
                return DropdownMenuItem(value: kab, child: Text(kab));
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Filter kategori
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  final cat = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      onSelected: (_) => _onFilterChanged(cat),
                      selectedColor: Colors.deepPurple,
                      labelStyle: TextStyle(
                        color: selectedCategory == cat
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // List tempat wisata
            Expanded(
              child: BlocBuilder<PlaceBloc, PlaceState>(
                bloc: _placeBloc,
                builder: (context, state) {
                  if (state is PlaceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PlaceLoaded) {
                    if (state.places.isEmpty) {
                      return const Center(child: Text('Tidak ada data'));
                    }
                    return ListView.builder(
                      itemCount: state.places.length,
                      itemBuilder: (context, index) {
                        final place = state.places[index];
                        return GestureDetector(
                          onTap: () {},
                          child: _buildPlaceCard(place),
                        );
                      },
                    );
                  } else if (state is PlaceError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard(PlaceResponseModel place) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'http://10.0.2.2:3000${place.photoUrl}',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  place.address.isNotEmpty
                      ? place.address
                      : 'Alamat tidak tersedia',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),

                const SizedBox(height: 4),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: double.tryParse(place.rating.toString()) ?? 0,
                      itemCount: 5,
                      itemSize: 16,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      place.rating.toString(),
                      style: const TextStyle(color: Colors.white),
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
