part of 'place_bloc.dart';

abstract class PlaceState {}

class PlaceInitial extends PlaceState {}

class PlaceLoading extends PlaceState {}

class PlaceLoaded extends PlaceState {
  final List<PlaceResponseModel> places;

  PlaceLoaded(this.places);
}

class PlaceError extends PlaceState {
  final String message;

  PlaceError(this.message);
}
