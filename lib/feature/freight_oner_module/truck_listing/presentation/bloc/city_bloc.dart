// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import 'city_event.dart';
import 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final GetCitiesUseCase getCitiesUseCase;

  CityBloc(this.getCitiesUseCase) : super(CityInitial()) {
    on<FetchCities>(_onFetchCities);
  }

  Future<void> _onFetchCities(
    FetchCities event,
    Emitter<CityState> emit,
  ) async {
    emit(CityLoading());

    final result = await getCitiesUseCase(NoParams());

    result.fold(
      (failure) => emit(CityError(failure.message)),
      (cities) => emit(CitySuccess(cities)),
    );
  }
}
