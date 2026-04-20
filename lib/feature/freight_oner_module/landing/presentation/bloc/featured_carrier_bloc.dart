import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/domain/usecases/get_featured_carriers_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/presentation/bloc/featured_carrier_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/presentation/bloc/featured_carrier_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedCarrierBloc
    extends Bloc<FeaturedCarrierEvent, FeaturedCarrierState> {
  final GetFeaturedCarriersUseCase getFeaturedCarriersUseCase;

  FeaturedCarrierBloc({required this.getFeaturedCarriersUseCase})
    : super(const FeaturedCarrierInitial()) {
    on<LoadFeaturedCarriers>(_onLoadFeaturedCarriers);
  }

  Future<void> _onLoadFeaturedCarriers(
    LoadFeaturedCarriers event,
    Emitter<FeaturedCarrierState> emit,
  ) async {
    emit(const FeaturedCarrierLoading());

    final result = await getFeaturedCarriersUseCase(NoParams());

    result.fold(
      (failure) => emit(FeaturedCarrierError(failure.message)),
      (response) => emit(FeaturedCarrierLoaded(response.data.featuredCarrier)),
    );
  }
}
