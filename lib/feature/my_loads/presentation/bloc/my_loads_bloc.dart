import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/feature/my_loads/domain/usecases/get_my_loads_usecase.dart';
import 'my_loads_event.dart';
import 'my_loads_state.dart';

class MyLoadsBloc extends Bloc<MyLoadsEvent, MyLoadsState> {
  final GetMyLoadsUseCase getMyLoadsUseCase;

  MyLoadsBloc(this.getMyLoadsUseCase) : super(MyLoadsInitial()) {
    on<FetchMyLoads>(_onFetch);
    on<RefreshMyLoads>(_onRefresh);
  }

  Future<void> _onFetch(FetchMyLoads event, Emitter<MyLoadsState> emit) async {
    emit(MyLoadsLoading());
    final result = await getMyLoadsUseCase(event.status);
    result.fold(
      (failure) => emit(MyLoadsError(failure.message)),
      (response) => emit(MyLoadsSuccess(response.freights ?? [], event.status)),
    );
  }

  Future<void> _onRefresh(
    RefreshMyLoads event,
    Emitter<MyLoadsState> emit,
  ) async {
    emit(MyLoadsLoading());
    final result = await getMyLoadsUseCase(event.status);
    result.fold(
      (failure) => emit(MyLoadsError(failure.message)),
      (response) => emit(MyLoadsSuccess(response.freights ?? [], event.status)),
    );
  }
}