// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import '../../domain/usecases/get_brands_usecase.dart';
import 'brand_event.dart';
import 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final GetBrandsUseCase getBrandsUseCase;

  BrandBloc(this.getBrandsUseCase) : super(BrandInitial()) {
    on<FetchBrands>(_onFetchBrands);
  }

  Future<void> _onFetchBrands(
    FetchBrands event,
    Emitter<BrandState> emit,
  ) async {
    emit(BrandLoading());

    final result = await getBrandsUseCase(NoParams());

    result.fold(
      (failure) => emit(BrandError(failure.message)),
      (brands) => emit(BrandSuccess(brands)),
    );
  }
}
