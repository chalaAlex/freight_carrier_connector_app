import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/usecase/get_my_carriers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_carriers_state.dart';

class MyCarriersBloc extends Cubit<MyCarriersState> {
  final GetMyCarriersUseCase getMyCarriersUseCase;

  MyCarriersBloc({required this.getMyCarriersUseCase})
    : super(MyCarriersInitial());

  Future<void> load() async {
    emit(MyCarriersLoading());
    final result = await getMyCarriersUseCase();
    result.fold(
      (failure) => emit(MyCarriersError(failure.message)),
      (response) => emit(MyCarriersSuccess(response.carriers ?? [])),
    );
  }
}
