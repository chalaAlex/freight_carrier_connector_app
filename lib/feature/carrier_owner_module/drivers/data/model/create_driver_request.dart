class CreateDriverRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String licenseNumber;
  final String licenseExpiry;
  final String licenseImageUrl;

  CreateDriverRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.licenseImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'licenseNumber': licenseNumber,
      'licenseExpiry': licenseExpiry,
      'licenseImage': licenseImageUrl,
    };
  }
}
