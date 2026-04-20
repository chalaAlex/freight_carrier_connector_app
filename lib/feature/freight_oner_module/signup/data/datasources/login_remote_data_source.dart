import 'package:clean_architecture/feature/freight_oner_module/signup/data/models/login_model.dart';
import 'package:clean_architecture/core/request/login_request.dart';

abstract class LoginRemoteDataSource {
  Future<LoginBaseResponse> login(LoginRequest loginRequest);
}
