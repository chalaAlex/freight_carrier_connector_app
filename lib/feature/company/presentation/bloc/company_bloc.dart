import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/feature/company/domain/usecase/get_company_detail_usecase.dart';
import 'package:clean_architecture/feature/company/domain/usecase/get_recommended_companies_usecase.dart';
import 'package:clean_architecture/feature/company/domain/usecase/get_top_rated_companies_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'company_event.dart';
import 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final GetRecommendedCompaniesUseCase getRecommendedCompaniesUseCase;
  final GetTopRatedCompaniesUseCase getTopRatedCompaniesUseCase;
  final GetCompanyDetailUseCase getCompanyDetailUseCase;

  CompanyBloc({
    required this.getRecommendedCompaniesUseCase,
    required this.getTopRatedCompaniesUseCase,
    required this.getCompanyDetailUseCase,
  }) : super(const RecommendedCompanyInitial()) {
    on<LoadRecommendedCompanies>(_onLoadRecommended);
    on<LoadTopRatedCompanies>(_onLoadTopRated);
    on<LoadCompanyDetail>(_onLoadDetail);
  }

  Future<void> _onLoadRecommended(
    LoadRecommendedCompanies event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const RecommendedCompanyLoading());
    final result = await getRecommendedCompaniesUseCase(NoParams());
    result.fold(
      (failure) => emit(RecommendedCompanyError(message: failure.message)),
      (response) => emit(
        RecommendedCompanyLoaded(companies: response.data?.companies ?? []),
      ),
    );
  }

  Future<void> _onLoadTopRated(
    LoadTopRatedCompanies event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const TopRatedCompanyLoading());
    final result = await getTopRatedCompaniesUseCase(NoParams());
    result.fold(
      (failure) => emit(TopRatedCompanyError(message: failure.message)),
      (response) => emit(
        TopRatedCompanyLoaded(companies: response.data?.companies ?? []),
      ),
    );
  }

  Future<void> _onLoadDetail(
    LoadCompanyDetail event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const CompanyDetailLoading());
    final result = await getCompanyDetailUseCase(event.id);
    result.fold(
      (failure) => emit(CompanyDetailError(message: failure.message)),
      (response) {
        if (response.company != null) {
          emit(CompanyDetailLoaded(company: response.company!));
        } else {
          emit(const CompanyDetailError(message: 'Company not found'));
        }
      },
    );
  }
}
