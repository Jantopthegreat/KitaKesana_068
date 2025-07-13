part of 'admin_place_bloc.dart';

abstract class AdminPlaceState {}

class AdminPlaceInitial extends AdminPlaceState {}

class AdminPlaceLoading extends AdminPlaceState {}

class AdminPlaceLoaded extends AdminPlaceState {
  final List<PlaceAdminResponseModel> places;

  AdminPlaceLoaded(this.places);
}

class AdminPlaceError extends AdminPlaceState {
  final String message;

  AdminPlaceError(this.message);
}

class AdminPlaceSuccess extends AdminPlaceState {
  final String message;

  AdminPlaceSuccess(this.message);
}

class AdminPlaceDeleted extends AdminPlaceState {
  final String message;

  AdminPlaceDeleted(this.message);
}
