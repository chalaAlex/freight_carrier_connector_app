import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/entity/company_entity.dart';

abstract class TopRatedCompanyState extends Equatable {
  const TopRatedCompanyState();

  @override
  List<Object?> get props => [];
}

class TopRatedCompanyInitial extends TopRatedCompanyState {
  const TopRatedCompanyInitial();
}

class TopRatedCompanyLoading extends TopRatedCompanyState {
  const TopRatedCompanyLoading();
}

class TopRatedCompanyLoaded extends TopRatedCompanyState {
  final List<CompanyEntity> companies;

  const TopRatedCompanyLoaded({required this.companies});

  @override
  List<Object?> get props => [companies];
}

class TopRatedCompanyError extends TopRatedCompanyState {
  final String message;

  const TopRatedCompanyError({required this.message});

  @override
  List<Object?> get props => [message];
}
