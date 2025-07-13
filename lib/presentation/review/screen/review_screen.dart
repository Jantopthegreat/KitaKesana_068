import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitakesana/data/models/request/review/post_review_request_model.dart';
import 'package:kitakesana/data/models/response/review/review_response_model.dart';
import 'package:kitakesana/data/repositories/review_repository.dart';
import 'package:kitakesana/presentation/review/bloc/review_bloc.dart';
import 'package:kitakesana/services/review_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReviewScreen extends StatefulWidget {
  final int placeId;

  const ReviewScreen({super.key, required this.placeId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late ReviewBloc _reviewBloc;
  double _rating = 0;
  final _commentController = TextEditingController();
  File? _selectedPhoto;
  int? _editingReviewId;
  int? _userId;
  final _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    final reviewService = ReviewService();
    final reviewRepository = ReviewRepository(reviewService: reviewService);
    _reviewBloc = ReviewBloc(repository: reviewRepository);
    _loadUserId();
    _reviewBloc.add(FetchReviewsEvent(placeId: widget.placeId));
  }

  void _loadUserId() async {
    final idStr = await _secureStorage.read(key: 'user_id');
    setState(() {
      _userId = int.tryParse(idStr ?? '');
    });
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedPhoto = File(picked.path));
    }
  }

  void _submitReview() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beri rating terlebih dahulu')),
      );
      return;
    }

    final request = PostReviewRequestModel(
      placeId: widget.placeId,
      rating: _rating,
      comment: _commentController.text,
      photo: _selectedPhoto,
    );

    if (_editingReviewId != null) {
      _reviewBloc.add(
        UpdateReviewEvent(
          reviewId: _editingReviewId!,
          placeId: widget.placeId,
          rating: _rating,
          comment: _commentController.text,
          photo: _selectedPhoto,
        ),
      );
    } else {
      _reviewBloc.add(
        PostReviewEvent(
          placeId: widget.placeId,
          rating: _rating,
          comment: _commentController.text,
          photo: _selectedPhoto,
        ),
      );
    }
  }

  void _fillFormForEdit(ReviewResponseModel? review) {
    if (review == null) return; // atau tampilkan error/snackbar

    setState(() {
      _editingReviewId = review.id;
      _commentController.text = review.comment;
      _rating = review.rating;
      // Tidak bisa auto-set photo karena tidak dapat File dari URL, kecuali kamu download
    });
  }

  void _resetForm() {
    setState(() {
      _rating = 0;
      _commentController.clear();
      _selectedPhoto = null;
      _editingReviewId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Ulasan'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        bloc: _reviewBloc,
        listener: (context, state) {
          if (state is ReviewError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ReviewPosted ||
              state is ReviewDeleted ||
              state is ReviewUpdated) {
            _resetForm();
            _reviewBloc.add(FetchReviewsEvent(placeId: widget.placeId));
          }
        },
        builder: (context, state) {
          if (_userId == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_editingReviewId == null)
                  const Text(
                    'Berikan Review Anda',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  allowHalfRating: true,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (value) => setState(() => _rating = value),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Tulis komentar...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickPhoto,
                      icon: const Icon(Icons.photo),
                      label: const Text('Tambah Foto'),
                    ),
                    const SizedBox(width: 8),
                    if (_selectedPhoto != null)
                      const Text(
                        '1 foto dipilih',
                        style: TextStyle(color: Colors.green),
                      ),
                    const Spacer(),
                    if (_editingReviewId != null)
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: _resetForm,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitReview,
                    child: Text(
                      _editingReviewId == null
                          ? 'Kirim Ulasan'
                          : 'Update Ulasan',
                    ),
                  ),
                ),
                const Divider(height: 32),

                Expanded(
                  child: state is ReviewLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is ReviewLoaded
                      ? _buildReviewList(state.reviews)
                      : const Text('Belum ada ulasan'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewList(List<ReviewResponseModel> reviews) {
    ReviewResponseModel? myReview;
    try {
      myReview = reviews.firstWhere((r) => r.userId == _userId);
    } catch (e) {
      myReview = null;
    }

    final otherReviews = reviews.where((r) => r.userId != _userId).toList();

    return ListView(
      children: [
        if (myReview != null)
          Card(
            color: Colors.grey[200],
            child: ListTile(
              title: Text('${myReview.userName} (Anda)'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(myReview.rating.toString()),
                    ],
                  ),
                  Text(myReview.comment),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _fillFormForEdit(myReview),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _reviewBloc.add(
                        DeleteReviewEvent(reviewId: myReview!.id),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

        ...otherReviews.map(
          (r) => ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/default_user.png'),
            ),
            title: Text(r.userName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(r.rating.toString()),
                  ],
                ),
                Text(r.comment),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
