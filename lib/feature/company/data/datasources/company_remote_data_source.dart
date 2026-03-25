import 'package:clean_architecture/feature/company/data/model/company_response.dart';

abstract class CompanyRemoteDataSource {
  Future<CompanyBaseResponse> getRecommendedCompanies();
  Future<CompanyBaseResponse> getTopRatedCompanies();
  Future<CompanyDetailResponse> getCompanyDetail(String id);
}
