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

  bool get isAuthenticated => _accessToken != null && _accessToken!.isNotEmpty;

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
      debugPrint('JWT decode error: $e');
      return {};
    }
  }

  String? getCurrentUserId() {
    if (_accessToken == null) return null;
    final payload = _decodeJwt(_accessToken!);
    final id = payload['Id']?.toString() ??
        payload['id']?.toString() ??
        payload['nameid']?.toString() ??
        payload['sub']?.toString() ??
        payload['UserId']?.toString();

    if (id != null && id.isNotEmpty) {
      debugPrint('✅ User ID from JWT: $id');
    } else {
      debugPrint('⚠️ JWT payload keys: ${payload.keys.toList()}');
    }
    return id;
  }

  Future<void> _saveUserId() async {
    final userId = getCurrentUserId();
    if (userId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      debugPrint('💾 User ID saved to prefs: $userId');
    }
  }

  void _saveTokensFromResponse(Map<String, dynamic> data) async {
    final tokenData = (data['data'] is Map) ? data['data'] as Map : data;
    final access = tokenData['accessToken']?.toString();
    final refresh = _extractRefreshToken(tokenData['refreshToken']);
    if (access != null && access.isNotEmpty) {
      await _saveTokens(access, refresh ?? '');
    }
  }

  static String? _extractRefreshToken(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) return value['tokenString']?.toString();
    return value.toString();
  }

  Future<http.Response> _get(String endpoint) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    return await http.get(Uri.parse(url), headers: _headers);
  }

  Future<http.Response> _post(String endpoint, Map<String, dynamic> body) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    return await http.post(Uri.parse(url), headers: _headers, body: jsonEncode(body));
  }

  Future<http.Response> _put(String endpoint, Map<String, dynamic> body) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    return await http.put(Uri.parse(url), headers: _headers, body: jsonEncode(body));
  }

  // ============== AUTH METHODS ==============
  Future<void> register(RegisterRequest request) async {
    final response = await _post(ApiConstants.register, request.toJson());
    debugPrint('REGISTER ${response.statusCode}: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _saveTokensFromResponse(data);
      await _saveUserId();
      return;
    }
    throw Exception(response.body);
  }

  Future<void> signIn(SignInRequest request) async {
    final response = await _post(ApiConstants.signIn, request.toJson());
    debugPrint('SIGNIN ${response.statusCode}: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _saveTokensFromResponse(data);
      await _saveUserId();
      return;
    }
    throw Exception(response.body);
  }

  Future<User?> getCurrentUser() async {
    final userId = getCurrentUserId();
    debugPrint('getCurrentUser — userId: $userId');

    if (userId == null || userId.isEmpty) return null;

    try {
      final response = await _get('${ApiConstants.getUserById}?id=$userId');
      debugPrint('GET USER ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final userData = (data['data'] is Map) ? data['data'] as Map<String, dynamic> : data;
        final user = User.fromJson(userData);
        debugPrint('✅ User loaded: ${user.firstName} ${user.lastName}');
        return user;
      } else if (response.statusCode == 403) {
        debugPrint('⚠️ 403 Forbidden on GetById - using local data if available');
      }
      return null;
    } catch (e) {
      debugPrint('getCurrentUser error: $e');
      return null;
    }
  }

  Future<void> editUser(EditUserRequest request) async {
    final response = await _put(ApiConstants.editUser, request.toJson());
    debugPrint('EDIT USER ${response.statusCode}: ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    final response = await _put(ApiConstants.changePassword, request.toJson());
    debugPrint('CHANGE PASSWORD ${response.statusCode}: ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(response.body);
    }
  }

  Future<void> logout() async {
    try {
      if (_accessToken != null) {
        await _post(ApiConstants.logout, {
          'accessToken': _accessToken,
          'refreshToken': _refreshToken,
        });
      }
    } catch (_) {}
    await clearTokens();
  }
}