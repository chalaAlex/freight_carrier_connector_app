import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/company/domain/entity/company_entity.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object?> get props => [];
}

// ── Recommended ───────────────────────────────────────────────────────────

class RecommendedCompanyInitial extends CompanyState {
  const RecommendedCompanyInitial();
}

class RecommendedCompanyLoading extends CompanyState {
  const RecommendedCompanyLoading();
}

class RecommendedCompanyLoaded extends CompanyState {
  final List<CompanyEntity> companies;
  const RecommendedCompanyLoaded({required this.companies});

  @override
  List<Object?> get props => [companies];
}

class RecommendedCompanyError extends CompanyState {
  final String message;
  const RecommendedCompanyError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ── Top Rated ─────────────────────────────────────────────────────────────

class TopRatedCompanyInitial extends CompanyState {
  const TopRatedCompanyInitial();
}

class TopRatedCompanyLoading extends CompanyState {
  const TopRatedCompanyLoading();
}

class TopRatedCompanyLoaded extends CompanyState {
  final List<CompanyEntity> companies;
  const TopRatedCompanyLoaded({required this.companies});

  @override
  List<Object?> get props => [companies];
}

class TopRatedCompanyError extends CompanyState {
  final String message;
  const TopRatedCompanyError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ── Company Detail ────────────────────────────────────────────────────────

class CompanyDetailInitial extends CompanyState {
  const CompanyDetailInitial();
}

class CompanyDetailLoading extends CompanyState {
  const CompanyDetailLoading();
}

class CompanyDetailLoaded extends CompanyState {
  final CompanyEntity company;
  const CompanyDetailLoaded({required this.company});

  @override
  List<Object?> get props => [company];
}

class CompanyDetailError extends CompanyState {
  final String message;
  const CompanyDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
