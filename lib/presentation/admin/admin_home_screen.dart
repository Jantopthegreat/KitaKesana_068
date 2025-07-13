import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kitakesana/data/models/response/review/review_latest_response_model.dart';
import 'package:kitakesana/presentation/admin/bloc/place/admin_place_bloc.dart';
import 'package:kitakesana/presentation/admin/bloc/review/admin_review_bloc.dart';
import 'package:kitakesana/presentation/admin/bloc/user/admin_user_bloc.dart';
import 'package:kitakesana/presentation/admin/wisata/home_wisata_admin_screen.dart';
import 'package:kitakesana/services/review_service.dart';
import 'package:kitakesana/services/admin_place_service.dart';
import 'package:kitakesana/data/repositories/admin/admin_place_repository.dart';
import 'package:kitakesana/presentation/admin/users/home_user_admin_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ReviewAdminBloc(reviewService: ReviewService())
            ..add(FetchAllReviewsEvent()),
      child: const _AdminDashboardContent(),
    );
  }
}

class _AdminDashboardContent extends StatelessWidget {
  const _AdminDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Header
            Container(
              color: Colors.lightBlue,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/default_user.png',
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Halo, Admin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.logout, color: Colors.white),
                  ),
                ],
              ),
            ),

            // ✅ Review Terbaru
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Review Terbaru',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 220,
                    child: BlocBuilder<ReviewAdminBloc, ReviewAdminState>(
                      builder: (context, state) {
                        if (state is ReviewAdminLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is ReviewAdminLoaded) {
                          return ListView.builder(
                            itemCount: state.reviews.length,
                            itemBuilder: (context, index) {
                              final review = state.reviews[index];
                              return _buildReviewItem(review);
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('Gagal memuat review'),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Menu Admin
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildDashboardBox(
                    title: 'Kelola Pengguna',
                    icon: Icons.people,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeUserAdminScreen(),
                        ),
                      );
                    },
                  ),

                  _buildDashboardBox(
                    title: 'Kelola Wisata',
                    icon: Icons.place,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeWisataAdminScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardBox(
                    title: 'Kelola Event',
                    icon: Icons.event,
                    onTap: () {},
                  ),
                  _buildDashboardBox(
                    title: 'Kelola Review',
                    icon: Icons.reviews,
                    onTap: () {
                      // TODO: Navigasi ke manajemen review jika ada
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardBox({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(ReviewLatestResponseModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/default_user.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: review.rating.toDouble(),
                      itemCount: 5,
                      itemSize: 14,
                      unratedColor: Colors.grey[300],
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                    ),
                    const SizedBox(width: 8),
                    Text('${review.rating}'),
                  ],
                ),
                const SizedBox(height: 6),
                Text(review.comment),
                const SizedBox(height: 6),
                if (review.photoUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'http://10.0.2.2:3000${review.photoUrl}',
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
