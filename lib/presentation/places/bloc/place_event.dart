part of 'place_bloc.dart';

abstract class PlaceEvent {}

class FetchPlacesEvent extends PlaceEvent {
  final String? kabupaten;
  final String? category;

  FetchPlacesEvent({this.kabupaten, this.category});
}

class FetchAllPlacesEvent extends PlaceEvent {}

class DeletePlaceEvent extends PlaceEvent {
  final int id;
  DeletePlaceEvent(this.id);
}
