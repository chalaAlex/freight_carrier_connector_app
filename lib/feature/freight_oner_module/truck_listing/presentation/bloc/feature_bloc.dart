// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import '../../domain/usecases/get_features_usecase.dart';
import 'feature_event.dart';
import 'feature_state.dart';

class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final GetFeaturesUseCase getFeaturesUseCase;

  FeatureBloc(this.getFeaturesUseCase) : super(FeatureInitial()) {
    on<FetchFeatures>(_onFetchFeatures);
  }

  Future<void> _onFetchFeatures(
    FetchFeatures event,
    Emitter<FeatureState> emit,
  ) async {
    emit(FeatureLoading());

    final result = await getFeaturesUseCase(NoParams());

    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (features) => emit(FeatureSuccess(features)),
    );
  }
}
