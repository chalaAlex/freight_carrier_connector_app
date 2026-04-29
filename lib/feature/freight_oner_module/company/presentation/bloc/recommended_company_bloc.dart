import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/usecase/get_recommended_companies_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/presentation/bloc/recommended_company_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/presentation/bloc/recommended_company_state.dart';

class RecommendedCompanyBloc
    extends Bloc<RecommendedCompanyEvent, RecommendedCompanyState> {
  final GetRecommendedCompaniesUseCase getRecommendedCompaniesUseCase;

  RecommendedCompanyBloc({required this.getRecommendedCompaniesUseCase})
    : super(const RecommendedCompanyInitial()) {
    on<LoadRecommendedCompanies>(_onLoadRecommendedCompanies);
  }

  Future<void> _onLoadRecommendedCompanies(
    LoadRecommendedCompanies event,
    Emitter<RecommendedCompanyState> emit,
  ) async {
    emit(const RecommendedCompanyLoading());

    final result = await getRecommendedCompaniesUseCase(NoParams());

    result.fold(
      (failure) => emit(RecommendedCompanyError(message: failure.message)),
      (response) =>
          emit(RecommendedCompanyLoaded(companies: response.data!.companies!)),
    );
  }
}
