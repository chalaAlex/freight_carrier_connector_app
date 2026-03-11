import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/feature/company/domain/usecase/get_top_rated_companies_usecase.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/top_rated_company_event.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/top_rated_company_state.dart';

class TopRatedCompanyBloc
    extends Bloc<TopRatedCompanyEvent, TopRatedCompanyState> {
  final GetTopRatedCompaniesUseCase getTopRatedCompaniesUseCase;

  TopRatedCompanyBloc({required this.getTopRatedCompaniesUseCase})
    : super(const TopRatedCompanyInitial()) {
    on<LoadTopRatedCompanies>(_onLoadTopRatedCompanies);
  }

  Future<void> _onLoadTopRatedCompanies(
    LoadTopRatedCompanies event,
    Emitter<TopRatedCompanyState> emit,
  ) async {
    emit(const TopRatedCompanyLoading());

    final result = await getTopRatedCompaniesUseCase(NoParams());

    result.fold(
      (failure) => emit(TopRatedCompanyError(message: failure.message)),
      (response) =>
          emit(TopRatedCompanyLoaded(companies: response.data.companies)),
    );
  }
}
