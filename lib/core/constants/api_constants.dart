class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://sm-api2.runasp.net';

  // Auth
  static const String register = '/api/Auth/register';
  static const String signIn = '/api/Auth/SignIn';
  static const String refreshToken = '/api/Auth/RefreshToken';
  static const String logout = '/api/Auth/Logout';

  // AppUser
  static const String createUser = '/api/AppUser/Create';
  static const String editUser = '/api/AppUser/Edit';
  static const String changePassword = '/api/AppUser/ChangePassword';
  static const String getUserById = '/api/AppUser/GetById';
}