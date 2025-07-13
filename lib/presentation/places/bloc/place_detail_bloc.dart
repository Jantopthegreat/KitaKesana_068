import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/data/models/response/place/place_detail_response_model.dart';
import 'package:kitakesana/services/place_service.dart';

part 'place_detail_event.dart';
part 'place_detail_state.dart';

class PlaceDetailBloc extends Bloc<PlaceDetailEvent, PlaceDetailState> {
  final PlaceService placeService;

  PlaceDetailBloc({required this.placeService}) : super(PlaceDetailInitial()) {
    on<FetchPlaceDetailEvent>((event, emit) async {
      emit(PlaceDetailLoading());
      try {
        final detail = await placeService.fetchPlaceDetail(event.placeId);
        emit(PlaceDetailLoaded(detail));
      } catch (e) {
        emit(PlaceDetailError('Gagal memuat detail tempat wisata'));
      }
    });
  }
}
