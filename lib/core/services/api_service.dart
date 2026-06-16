import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/auth_models.dart';
import '../../models/user_models.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _accessToken;
  String? _refreshToken;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  Future<void> _saveTokens(String access, String refresh) async {
    _accessToken = access;
    _refreshToken = refresh;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', access);
    await prefs.setString('refreshToken', refresh);
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken');
    _refreshToken = prefs.getString('refreshToken');
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  bool get isAuthenticated => _accessToken != null;
  String? get accessToken => _accessToken;

  Map<String, dynamic> _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};
      String payload = parts[1];
      switch (payload.length % 4) {
        case 2: payload += '=='; break;
        case 3: payload += '='; break;
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      debugPrint("JWT decode error: $e");
      return {};
    }
  }

  String? getCurrentUserId() {
    if (_accessToken == null) return null;
    final payload = _decodeJwt(_accessToken!);
    return payload['Id']?.toString() ?? payload['nameid']?.toString();
  }

  // The backend returns refreshToken as an OBJECT:
  //   "refreshToken": { "tokenString": "...", "expireAt": "..." }
  // not as a plain string. This safely extracts the string in either case.
  String? _extractRefreshToken(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) return value['tokenString']?.toString();
    return value.toString();
  }

  Future<http.Response> _get(String endpoint) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    debugPrint('GET: $url');
    return await http.get(
      Uri.parse(url),
      headers: _headers,
    );
  }

  Future<http.Response> _post(String endpoint, Map<String, dynamic> body) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    debugPrint('POST: $url');
    debugPrint('BODY: ${jsonEncode(body)}');
    return await http.post(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> _put(String endpoint, Map<String, dynamic> body) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    debugPrint('PUT: $url');
    debugPrint('BODY: ${jsonEncode(body)}');
    return await http.put(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _post(ApiConstants.register, request.toJson());
    debugPrint('REGISTER STATUS: ${response.statusCode}');
    debugPrint('REGISTER BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception('Registration failed: ${response.body}');
  }

  Future<AuthResponse> signIn(SignInRequest request) async {
    final response = await _post(ApiConstants.signIn, request.toJson());
    debugPrint('LOGIN STATUS: ${response.statusCode}');
    debugPrint('LOGIN BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tokenData = data['data'] ?? data;

      if (tokenData['accessToken'] != null) {
        await _saveTokens(
            tokenData['accessToken'],
            _extractRefreshToken(tokenData['refreshToken']) ?? ''
        );
      }
      return AuthResponse.fromJson(data);
    }
    throw Exception('Sign in failed: ${response.body}');
  }

  Future<AuthResponse> refreshToken() async {
    if (_refreshToken == null || _accessToken == null) {
      throw Exception('No tokens available');
    }
    final request = RefreshTokenRequest(
      accessToken: _accessToken!,
      refreshToken: _refreshToken!,
    );
    final response = await _post(ApiConstants.refreshToken, request.toJson());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tokenData = data['data'] ?? data;
      if (tokenData['accessToken'] != null) {
        await _saveTokens(
            tokenData['accessToken'],
            _extractRefreshToken(tokenData['refreshToken']) ?? _refreshToken!
        );
      }
      return AuthResponse.fromJson(data);
    }
    throw Exception('Token refresh failed');
  }

  Future<void> logout() async {
    if (_accessToken != null && _refreshToken != null) {
      final request = LogoutRequest(
        accessToken: _accessToken!,
        refreshToken: _refreshToken!,
      );
      await _post(ApiConstants.logout, request.toJson());
    }
    await clearTokens();
  }

  Future<User?> getCurrentUser() async {
    final userId = getCurrentUserId();
    if (userId == null) return null;

    try {
      final response = await _get('${ApiConstants.getUserById}?id=$userId');
      debugPrint('GET USER STATUS: ${response.statusCode}');
      debugPrint('GET USER BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data'] ?? data;
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      debugPrint('Get user error: $e');
      return null;
    }
  }

  Future<void> createUser(CreateUserRequest request) async {
    final response = await _post(ApiConstants.createUser, request.toJson());
    if (response.statusCode != 200) {
      throw Exception('Create user failed: ${response.body}');
    }
  }

  Future<void> editUser(EditUserRequest request) async {
    final response = await _put(ApiConstants.editUser, request.toJson());
    debugPrint('EDIT USER STATUS: ${response.statusCode}');
    debugPrint('EDIT USER BODY: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Edit user failed: ${response.body}');
    }
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    final response = await _put(ApiConstants.changePassword, request.toJson());
    debugPrint('CHANGE PASSWORD STATUS: ${response.statusCode}');
    debugPrint('CHANGE PASSWORD BODY: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Change password failed: ${response.body}');
    }
  }
}