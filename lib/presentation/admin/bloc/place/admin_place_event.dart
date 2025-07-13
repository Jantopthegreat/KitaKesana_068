part of 'admin_place_bloc.dart';

abstract class AdminPlaceEvent {}

class FetchAdminPlacesEvent extends AdminPlaceEvent {}

class DeleteAdminPlaceEvent extends AdminPlaceEvent {
  final int id;

  DeleteAdminPlaceEvent(this.id);
}

class CreateAdminPlaceEvent extends AdminPlaceEvent {
  final PostPlaceAdminRequestModel request;

  CreateAdminPlaceEvent(this.request);
}

class UpdateAdminPlaceEvent extends AdminPlaceEvent {
  final int id;
  final PostPlaceAdminRequestModel request;

  UpdateAdminPlaceEvent(this.id, this.request);
}
