import 'package:clean_architecture/feature/signup/data/models/sign_up_model.dart';
import 'package:clean_architecture/core/request/sign_up_request.dart';

abstract class SignUpRemoteDataSource {
  Future<SignUpModel> signUp(SignUpRequest signUpRequest);
}
