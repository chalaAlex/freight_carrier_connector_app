import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/data/model/company_response.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/data/datasources/company_remote_data_source.dart';

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

  @override
  Future<CompanyDetailResponse> getCompanyDetail(String id) async {
    return await client.getCompanyDetail(id);
  }
}
