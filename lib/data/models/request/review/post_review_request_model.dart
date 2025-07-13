import 'dart:io';

class PostReviewRequestModel {
  final int placeId;
  final double rating;
  final String? comment;
  final File? photo;

  PostReviewRequestModel({
    required this.placeId,
    required this.rating,
    this.comment,
    this.photo,
  });

  Map<String, String> toFields() {
    return {
      'place_id': placeId.toString(),
      'rating': rating.toString(),
      if (comment != null) 'comment': comment!,
    };
  }
}
