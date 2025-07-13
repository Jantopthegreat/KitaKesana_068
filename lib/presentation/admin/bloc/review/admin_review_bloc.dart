import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/data/models/response/review/review_latest_response_model.dart';
import 'package:kitakesana/services/review_service.dart';

part 'admin_review_event.dart';
part 'admin_review_state.dart';

class ReviewAdminBloc extends Bloc<ReviewAdminEvent, ReviewAdminState> {
  final ReviewService reviewService;

  ReviewAdminBloc({required this.reviewService}) : super(ReviewAdminInitial()) {
    on<FetchAllReviewsEvent>((event, emit) async {
      emit(ReviewAdminLoading());
      try {
        final reviews = await reviewService.getAllReviews();
        emit(ReviewAdminLoaded(reviews));
      } catch (e) {
        emit(ReviewAdminError('Gagal memuat review: $e'));
      }
    });
  }
}
