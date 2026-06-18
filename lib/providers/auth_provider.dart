import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../models/auth_models.dart';
import '../models/user_models.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _error;
  bool _isAuthenticated = false;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    await _api.loadTokens();
    _isAuthenticated = _api.isAuthenticated;
    if (_isAuthenticated) {
      _currentUser = await _api.getCurrentUser();
    }
    _isLoading = false;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    String s = e.toString();
    final idx = s.indexOf('{');
    if (idx >= 0) {
      try {
        final data = jsonDecode(s.substring(idx)) as Map;
        final msg = data['message'] ?? data['Message'];
        if (msg is String && msg.isNotEmpty) return msg;
        final errors = data['errors'];
        if (errors is Map) {
          final parts = <String>[];
          errors.forEach((k, v) {
            if (v is List && v.isNotEmpty) parts.add(v.first.toString());
            else if (v is String) parts.add(v);
          });
          if (parts.isNotEmpty) return parts.join(' ');
        }
      } catch (_) {}
    }
    return s
        .replaceAll('Exception: ', '')
        .replaceAll('Registration failed: ', '')
        .replaceAll('Sign in failed: ', '')
        .replaceAll('Edit user failed: ', '')
        .replaceAll('Change password failed: ', '');
  }

  Future<bool> registerAndLogin({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String nationalId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.register(RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        nationalId: nationalId,
      ));
      if (!_api.isAuthenticated) {
        await _api.signIn(SignInRequest(userName: email, password: password));
      }
      _currentUser = await _api.getCurrentUser();
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String userName,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.signIn(SignInRequest(userName: userName, password: password));
      _currentUser = await _api.getCurrentUser();
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getCurrentUser() async {
    _currentUser = await _api.getCurrentUser();
    notifyListeners();
  }

  Future<bool> editUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.editUser(EditUserRequest(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
      ));
      _currentUser = await _api.getCurrentUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String id,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    if (newPassword != confirmPassword) {
      _error = 'Passwords do not match';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    if (newPassword.length < 6) {
      _error = 'Password must be at least 6 characters';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    try {
      await _api.changePassword(ChangePasswordRequest(
        id: id,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _api.logout();
      _isAuthenticated = false;
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}