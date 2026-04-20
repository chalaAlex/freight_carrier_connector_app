// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import '../../domain/usecases/get_regions_usecase.dart';
import 'region_event.dart';
import 'region_state.dart';

class RegionBloc extends Bloc<RegionEvent, RegionState> {
  final GetRegionsUseCase getRegionsUseCase;

  RegionBloc(this.getRegionsUseCase) : super(RegionInitial()) {
    on<FetchRegions>(_onFetchRegions);
  }

  Future<void> _onFetchRegions(
    FetchRegions event,
    Emitter<RegionState> emit,
  ) async {
    emit(RegionLoading());

    final result = await getRegionsUseCase(NoParams());

    result.fold(
      (failure) => emit(RegionError(failure.message)),
      (regions) => emit(RegionSuccess(regions)),
    );
  }
}
