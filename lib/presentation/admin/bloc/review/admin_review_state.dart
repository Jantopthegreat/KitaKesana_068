part of 'admin_review_bloc.dart';

abstract class ReviewAdminState {}

class ReviewAdminInitial extends ReviewAdminState {}

class ReviewAdminLoading extends ReviewAdminState {}

class ReviewAdminLoaded extends ReviewAdminState {
  final List<ReviewLatestResponseModel> reviews;

  ReviewAdminLoaded(this.reviews);
}

class ReviewAdminError extends ReviewAdminState {
  final String message;

  ReviewAdminError(this.message);
}
