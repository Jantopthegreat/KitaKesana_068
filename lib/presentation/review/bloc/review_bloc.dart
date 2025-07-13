import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/data/models/request/review/post_review_request_model.dart';
import 'package:kitakesana/data/repositories/review_repository.dart';
import 'package:kitakesana/data/models/response/review/review_response_model.dart';
import 'dart:io';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc({required this.repository}) : super(ReviewInitial()) {
    on<FetchReviewsEvent>(_onFetch);
    on<PostReviewEvent>(_onPost);
    on<UpdateReviewEvent>(_onUpdate);
    on<DeleteReviewEvent>(_onDelete);
  }

  Future<void> _onFetch(
    FetchReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final reviews = await repository.getReviewsByPlace(event.placeId);
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onPost(PostReviewEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final request = PostReviewRequestModel(
        placeId: event.placeId,
        rating: event.rating,
        comment: event.comment,
        photo: event.photo,
      );
      await repository.createReview(request);
      emit(ReviewSuccess('Review berhasil ditambahkan'));
      add(FetchReviewsEvent(placeId: event.placeId));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final request = PostReviewRequestModel(
        placeId: event.placeId,
        rating: event.rating,
        comment: event.comment,
        photo: event.photo,
      );
      await repository.updateReview(event.reviewId, request);
      emit(ReviewSuccess('Review berhasil diperbarui'));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      await repository.deleteReview(event.reviewId);
      emit(ReviewSuccess('Review berhasil dihapus'));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
