// SignUp Request Model
class SignUpRequest {
  String firstName;
  String lastName;
  String email;
  String phone;
  String password;
  String passwordConfirm;
  String role;

  SignUpRequest(
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.password,
    this.passwordConfirm,
    this.role,
  );
}

