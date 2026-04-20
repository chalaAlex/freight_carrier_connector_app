import 'package:equatable/equatable.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecommendedCompanies extends CompanyEvent {
  const LoadRecommendedCompanies();
}

class LoadTopRatedCompanies extends CompanyEvent {
  const LoadTopRatedCompanies();
}

class LoadCompanyDetail extends CompanyEvent {
  final String id;
  const LoadCompanyDetail(this.id);

  @override
  List<Object?> get props => [id];
}
