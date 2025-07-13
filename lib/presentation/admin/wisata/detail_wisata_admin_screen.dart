import 'package:flutter/material.dart';
import 'package:kitakesana/data/models/response/place/place_detail_response_model.dart';
import 'package:kitakesana/data/repositories/place_repository.dart';

class DetailPlaceScreen extends StatefulWidget {
  final int placeId;
  const DetailPlaceScreen({super.key, required this.placeId});

  @override
  State<DetailPlaceScreen> createState() => _DetailPlaceScreenState();
}

class _DetailPlaceScreenState extends State<DetailPlaceScreen> {
  final _repository = PlaceRepository();
  late Future<PlaceDetailResponse> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _repository.getPlaceDetail(widget.placeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tempat Wisata'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<PlaceDetailResponse>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Gagal memuat detail'));
          }

          final place = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    place.photoUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  place.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Kategori ID: ${place.categoryId}'),
                Text('Kabupaten: ${place.kabupaten}'),
                Text('Alamat: ${place.address}'),
                const SizedBox(height: 8),
                Text('Latitude: ${place.latitude}'),
                Text('Longitude: ${place.longitude}'),
                const SizedBox(height: 8),
                Text('Deskripsi:'),
                Text(place.description),
                const SizedBox(height: 12),
                Text('Dibuat oleh: ${place.createdBy}'),
                Text('Tanggal dibuat: ${place.createdAt.toLocal()}'),
                const SizedBox(height: 16),
                Text(
                  'Rating: ${place.averageRating} dari ${place.reviewCount} review',
                ),
                const SizedBox(height: 8),

                // List Review
                const Text(
                  'Ulasan Terbaru:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  children: place.reviews.map((r) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Rating: ${r.rating}'),
                          Text(r.comment),
                          if (r.photoUrl != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Image.network(
                                r.photoUrl!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
