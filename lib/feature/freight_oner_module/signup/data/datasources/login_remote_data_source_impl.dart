import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/datasources/login_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/models/login_model.dart';
import 'package:clean_architecture/core/request/login_request.dart';

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiClient client;

  LoginRemoteDataSourceImpl({required this.client});

  @override
  Future<LoginBaseResponse> login(LoginRequest loginRequest) async {
    return await client.login(loginRequest.email, loginRequest.password);
  }
}
