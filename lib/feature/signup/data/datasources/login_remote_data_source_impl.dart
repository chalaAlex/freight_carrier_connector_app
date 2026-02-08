import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/signup/data/datasources/login_remote_data_source.dart';
import 'package:clean_architecture/feature/signup/data/models/login_model.dart';
import 'package:clean_architecture/core/request/login_request.dart';

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiClient client;

  LoginRemoteDataSourceImpl({required this.client});

  @override
  Future<LoginBaseResponse> login(LoginRequest loginRequest) async {
    final resp = await client.login(loginRequest.email, loginRequest.password);
    // Debug: print raw JSON to help diagnose null fields in mapped entity
    try {
      // LoginBaseResponse has toJson via generated code
      print('DEBUG: Raw login response json: ${resp.toJson()}');
    } catch (e) {
      print('DEBUG: Could not toJson login response: $e');
    }
    return resp;
  }
}
