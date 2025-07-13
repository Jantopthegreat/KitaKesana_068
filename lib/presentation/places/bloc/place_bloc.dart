import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:kitakesana/data/models/response/place/place_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/services/place_service.dart';
import 'package:kitakesana/data/models/response/place/place_response_model.dart';
part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final PlaceService placeService;

  PlaceBloc({required this.placeService}) : super(PlaceInitial()) {
    on<FetchPlacesEvent>((event, emit) async {
      emit(PlaceLoading());

      try {
        final List<PlaceResponseModel> places = await placeService
            .fetchRecommendedPlaces(kabupaten: event.kabupaten);
        emit(PlaceLoaded(places));
      } catch (e) {
        emit(PlaceError('Gagal memuat data tempat wisata'));
      }
    });
  }
}
