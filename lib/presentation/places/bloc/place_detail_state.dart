part of 'place_detail_bloc.dart';

abstract class PlaceDetailState {}

class PlaceDetailInitial extends PlaceDetailState {}

class PlaceDetailLoading extends PlaceDetailState {}

class PlaceDetailLoaded extends PlaceDetailState {
  final PlaceDetailResponse place;

  PlaceDetailLoaded(this.place);
}

class PlaceDetailError extends PlaceDetailState {
  final String message;

  PlaceDetailError(this.message);
}
