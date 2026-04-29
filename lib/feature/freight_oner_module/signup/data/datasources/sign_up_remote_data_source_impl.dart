import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/models/sign_up_model.dart';
import 'package:clean_architecture/core/request/sign_up_request.dart';
import 'sign_up_remote_data_source.dart';

class SignUpRemoteDataSourceImpl implements SignUpRemoteDataSource {
  final ApiClient client;

  SignUpRemoteDataSourceImpl({required this.client});

  @override
  Future<SignUpModel> signUp(SignUpRequest signUpRequest) async{
    return await client.signUp( 
      signUpRequest.firstName,
      signUpRequest.lastName,
      signUpRequest.email,
      signUpRequest.phone,
      signUpRequest.password,
      signUpRequest.passwordConfirm,
      signUpRequest.role
    );
  }
}
