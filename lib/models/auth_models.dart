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

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'nationalId': nationalId,
  };
}

class SignInRequest {
  final String userName;
  final String password;

  SignInRequest({
    required this.userName,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'password': password,
  };
}

class RefreshTokenRequest {
  final String accessToken;
  final String refreshToken;

  RefreshTokenRequest({
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}

class LogoutRequest {
  final String accessToken;
  final String refreshToken;

  LogoutRequest({
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? message;
  final bool success;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.message,
    required this.success,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // The backend's `data` wrapper sometimes nests the tokens one level
    // deeper (json['data']['accessToken']) instead of top-level.
    final tokenSource = (json['data'] is Map) ? json['data'] as Map : json;

    return AuthResponse(
      accessToken: tokenSource['accessToken']?.toString(),
      refreshToken: _stringifyRefreshToken(tokenSource['refreshToken']),
      // 'message' can come back as a String OR as a Map (validation errors
      // like {"email": "already taken"}). Casting a Map directly to String
      // throws "_Map<String, dynamic> is not a subtype of String" at
      // runtime, so convert safely instead.
      message: _stringifyMessage(json['message'] ?? json['Message']),
      success: json['succeeded'] ?? json['success'] ?? true,
    );
  }

  static String? _stringifyMessage(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) {
      return value.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    }
    return value.toString();
  }

  // The backend returns refreshToken as an OBJECT:
  //   "refreshToken": { "tokenString": "...", "expireAt": "..." }
  // not as a plain string. This safely extracts the string in either case.
  static String? _stringifyRefreshToken(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) return value['tokenString']?.toString();
    return value.toString();
  }
}

class CreateUserRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String roleName;

  CreateUserRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.roleName,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneNumber': phoneNumber,
    'password': password,
    'roleName': roleName,
  };
}

class EditUserRequest {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  EditUserRequest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneNumber': phoneNumber,
  };
}

class ChangePasswordRequest {
  final String id;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.id,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'currentPassword': currentPassword,
    'newPassword': newPassword,
    'confirmPassword': confirmPassword,
  };
}