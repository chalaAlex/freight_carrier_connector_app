import 'package:clean_architecture/feature/company/data/company_response.dart';

abstract class CompanyRemoteDataSource {
  Future<CompanyBaseResponse> getRecommendedCompanies();
}
