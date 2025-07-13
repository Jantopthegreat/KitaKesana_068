import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/services/admin_place_service.dart';
import 'package:kitakesana/data/models/response/admin/place/place_admin_response_model.dart';
import 'package:kitakesana/data/models/request/admin/place/post_place_admin_request_model.dart';

part 'admin_place_event.dart';
part 'admin_place_state.dart';

// ... class AdminPlaceBloc di sini
class AdminPlaceBloc extends Bloc<AdminPlaceEvent, AdminPlaceState> {
  final AdminPlaceService placeService;

  AdminPlaceBloc({required this.placeService}) : super(AdminPlaceInitial()) {
    on<FetchAdminPlacesEvent>((event, emit) async {
      emit(AdminPlaceLoading());
      try {
        final places = await placeService.fetchAllPlaces();
        emit(AdminPlaceLoaded(places));
      } catch (e) {
        emit(AdminPlaceError(e.toString()));
      }
    });

    on<DeleteAdminPlaceEvent>((event, emit) async {
      emit(AdminPlaceLoading());
      try {
        await placeService.deletePlace(event.id);
        add(FetchAdminPlacesEvent()); // Refresh after delete
      } catch (e) {
        emit(AdminPlaceError(e.toString()));
      }
    });

    on<CreateAdminPlaceEvent>((event, emit) async {
      emit(AdminPlaceLoading());
      try {
        await placeService.createPlace(event.request);
        emit(AdminPlaceSuccess("Tempat berhasil ditambahkan"));
        add(FetchAdminPlacesEvent());
      } catch (e) {
        emit(AdminPlaceError(e.toString()));
      }
    });

    on<UpdateAdminPlaceEvent>((event, emit) async {
      emit(AdminPlaceLoading());
      try {
        await placeService.updatePlace(event.id, event.request);
        emit(AdminPlaceSuccess("Tempat berhasil diperbarui"));
        add(FetchAdminPlacesEvent());
      } catch (e) {
        emit(AdminPlaceError(e.toString()));
      }
    });
  }
}
