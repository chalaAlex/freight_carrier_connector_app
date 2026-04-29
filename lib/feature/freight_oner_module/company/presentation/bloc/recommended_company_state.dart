import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/entity/company_entity.dart';

abstract class RecommendedCompanyState extends Equatable {
  const RecommendedCompanyState();

  @override
  List<Object?> get props => [];
}

class RecommendedCompanyInitial extends RecommendedCompanyState {
  const RecommendedCompanyInitial();
}

class RecommendedCompanyLoading extends RecommendedCompanyState {
  const RecommendedCompanyLoading();
}

class RecommendedCompanyLoaded extends RecommendedCompanyState {
  final List<CompanyEntity> companies;

  const RecommendedCompanyLoaded({required this.companies});

  @override
  List<Object?> get props => [companies];
}

class RecommendedCompanyError extends RecommendedCompanyState {
  final String message;

  const RecommendedCompanyError({required this.message});

  @override
  List<Object?> get props => [message];
}
