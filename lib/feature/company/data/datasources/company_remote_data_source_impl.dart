import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/company/data/model/company_response.dart';
import 'package:clean_architecture/feature/company/data/datasources/company_remote_data_source.dart';

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final ApiClient client;

  CompanyRemoteDataSourceImpl({required this.client});

  @override
  Future<CompanyBaseResponse> getRecommendedCompanies() async {
    return await client.getRecommendedCompanies();
  }

  @override
  Future<CompanyBaseResponse> getTopRatedCompanies() async {
    return await client.getTopRatedCompanies();
  }
}
