import 'package:equatable/equatable.dart';

abstract class TopRatedCompanyEvent extends Equatable {
  const TopRatedCompanyEvent();

  @override
  List<Object?> get props => [];
}

class LoadTopRatedCompanies extends TopRatedCompanyEvent {
  const LoadTopRatedCompanies();
}
