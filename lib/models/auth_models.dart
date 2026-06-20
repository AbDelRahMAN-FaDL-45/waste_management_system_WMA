class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String nationalId;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.nationalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
    };
  }
}

class SignInRequest {
  final String userName;
  final String password;

  SignInRequest({
    required this.userName,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
    };
  }
}

class EditUserRequest {
  final String id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? nationalId;
  final String? email;

  EditUserRequest({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.nationalId,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'email': email,
    };
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    };
  }
}