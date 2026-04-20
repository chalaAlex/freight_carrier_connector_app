import 'package:equatable/equatable.dart';

abstract class RecommendedCompanyEvent extends Equatable {
  const RecommendedCompanyEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecommendedCompanies extends RecommendedCompanyEvent {
  const LoadRecommendedCompanies();
}
