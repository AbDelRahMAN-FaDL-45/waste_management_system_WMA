// lib/models/user_models.dart

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? nationalId;
  final String? roleName;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.nationalId,
    this.roleName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      // Backend may return this as "nationalId" or "nationalID"
      nationalId: (json['nationalId'] ?? json['nationalID'])?.toString(),
      roleName: json['roleName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneNumber': phoneNumber,
    if (nationalId != null) 'nationalId': nationalId,
    if (roleName != null) 'roleName': roleName,
  };
}