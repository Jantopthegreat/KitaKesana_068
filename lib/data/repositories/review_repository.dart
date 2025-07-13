import 'package:kitakesana/data/models/request/review/post_review_request_model.dart';
import 'package:kitakesana/data/models/response/review/review_response_model.dart';
import 'package:kitakesana/services/review_service.dart';

class ReviewRepository {
  final ReviewService _reviewService;

  ReviewRepository({ReviewService? reviewService})
    : _reviewService = reviewService ?? ReviewService();

  Future<List<ReviewResponseModel>> getReviewsByPlace(int placeId) {
    return _reviewService.fetchReviewsByPlace(placeId);
  }

  Future<void> createReview(PostReviewRequestModel request) {
    return _reviewService.postReview(request);
  }

  Future<void> updateReview(int id, PostReviewRequestModel request) {
    return _reviewService.updateReview(id, request);
  }

  Future<void> deleteReview(int id) {
    return _reviewService.deleteReview(id);
  }
}
