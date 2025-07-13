part of 'review_bloc.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewResponseModel> reviews;

  ReviewLoaded(this.reviews);
}

class ReviewSuccess extends ReviewState {
  final String message;

  ReviewSuccess(this.message);
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);
}

class ReviewPosted extends ReviewState {}

class ReviewDeleted extends ReviewState {}

class ReviewUpdated extends ReviewState {}
