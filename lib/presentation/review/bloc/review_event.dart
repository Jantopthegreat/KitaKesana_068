part of 'review_bloc.dart';

abstract class ReviewEvent {}

class FetchReviewsEvent extends ReviewEvent {
  final int placeId;

  FetchReviewsEvent({required this.placeId});
}

class PostReviewEvent extends ReviewEvent {
  final int placeId;
  final double rating;
  final String comment;
  final File? photo;

  PostReviewEvent({
    required this.placeId,
    required this.rating,
    required this.comment,
    this.photo,
  });
}

class UpdateReviewEvent extends ReviewEvent {
  final int reviewId;
  final int placeId; // Tambahkan ini
  final double rating;
  final String comment;
  final File? photo;

  UpdateReviewEvent({
    required this.reviewId,
    required this.placeId,
    required this.rating,
    required this.comment,
    this.photo,
  });
}

class DeleteReviewEvent extends ReviewEvent {
  final int reviewId;

  DeleteReviewEvent({required this.reviewId});
}
