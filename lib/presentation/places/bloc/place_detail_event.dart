part of 'place_detail_bloc.dart';

abstract class PlaceDetailEvent {}

class FetchPlaceDetailEvent extends PlaceDetailEvent {
  final int placeId;

  FetchPlaceDetailEvent(this.placeId);
}
