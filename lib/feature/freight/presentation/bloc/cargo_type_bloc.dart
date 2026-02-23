import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_cargo_types_usecase.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargo_type_event.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargo_type_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CargoTypeBloc extends Bloc<CargoTypeEvent, CargoTypeState> {
  final GetCargoTypesUseCase _getCargoTypesUseCase;

  CargoTypeBloc(this._getCargoTypesUseCase) : super(const CargoTypeInitial()) {
    on<FetchCargoTypesEvent>(_onFetchCargoTypes);
  }

  Future<void> _onFetchCargoTypes(
    FetchCargoTypesEvent event,
    Emitter<CargoTypeState> emit,
  ) async {
    emit(const CargoTypeLoading());

    final result = await _getCargoTypesUseCase(NoParams());

    result.fold((Failure failure) => emit(CargoTypeError(failure.message)), (
      response,
    ) {
      if (response.data != null) {
        emit(CargoTypeLoaded(response.data!));
      } else {
        emit(const CargoTypeError('No cargo types found'));
      }
    });
  }
}
