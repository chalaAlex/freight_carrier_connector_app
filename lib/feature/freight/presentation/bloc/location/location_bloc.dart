// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_locations_usecase.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetLocationsUseCase getLocationsUseCase;

  LocationBloc({required this.getLocationsUseCase}) : super(LocationInitial()) {
    on<FetchRegionsEvent>(_onFetchRegions);
    on<FetchCitiesEvent>(_onFetchCities);
  }

  Future<void> _onFetchRegions(
    FetchRegionsEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    final result = await getLocationsUseCase(LocationParams());

    result.fold((Failure failure) => emit(LocationError(failure.message)), (
      response,
    ) {
      if (response.data != null) {
        emit(LocationLoaded(response.data!));
      } else {
        emit(const LocationError('No regions found'));
      }
    });
  }

  Future<void> _onFetchCities(
    FetchCitiesEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    final result = await getLocationsUseCase(
      LocationParams(region: event.region),
    );

    result.fold((Failure failure) => emit(LocationError(failure.message)), (
      response,
    ) {
      if (response.data != null) {
        emit(LocationLoaded(response.data!));
      } else {
        emit(const LocationError('No cities found'));
      }
    });
  }
}
