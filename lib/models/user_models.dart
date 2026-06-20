class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? nationalId;
  final String? role;
  final bool? isActive;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.nationalId,
    this.role,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? json['Id']?.toString(),
      firstName: json['firstName'] ?? json['FirstName'],
      lastName: json['lastName'] ?? json['LastName'],
      email: json['email'] ?? json['Email'],
      phoneNumber: json['phoneNumber'] ?? json['PhoneNumber'],
      nationalId: json['nationalId'] ?? json['NationalId'],
      role: json['role'] ?? json['Role'],
      isActive: json['isActive'] ?? json['IsActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'role': role,
      'isActive': isActive,
    };
  }
}