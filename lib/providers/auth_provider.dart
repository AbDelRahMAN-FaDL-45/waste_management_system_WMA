import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../models/auth_models.dart';
import '../models/user_models.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await _apiService.loadTokens();
    _isAuthenticated = _apiService.isAuthenticated;
    if (_isAuthenticated) {
      await getCurrentUser();
    }
    notifyListeners();
  }

  String _extractErrorMessage(dynamic error) {
    String errorMsg = error.toString();

    if (errorMsg.contains('{')) {
      try {
        final jsonStart = errorMsg.indexOf('{');
        final jsonStr = errorMsg.substring(jsonStart);
        final errorData = jsonDecode(jsonStr);

        // Handle case where message is a Map (like validation errors)
        final message = errorData['message'];
        if (message is String) {
          return message;
        } else if (message is Map) {
          // Flatten validation errors
          return message.entries.map((e) => '${e.key}: ${e.value}').join('\n');
        }

        final msg = errorData['Message'];
        if (msg is String) return msg;
        if (msg is Map) {
          return msg.entries.map((e) => '${e.key}: ${e.value}').join('\n');
        }

        return errorData.toString();
      } catch (_) {
        errorMsg = errorMsg.replaceAll('Exception: ', '');
        errorMsg = errorMsg.replaceAll('Registration failed: ', '');
        errorMsg = errorMsg.replaceAll('Sign in failed: ', '');
        errorMsg = errorMsg.replaceAll('Edit user failed: ', '');
        errorMsg = errorMsg.replaceAll('Change password failed: ', '');
      }
    }

    return errorMsg;
  }

  Future<void> getCurrentUser() async {
    _currentUser = await _apiService.getCurrentUser();
    notifyListeners();
  }

  Future<bool> register({
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
      final request = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        nationalId: nationalId,
      );
      await _apiService.register(request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractErrorMessage(e);
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
      final request = SignInRequest(
        userName: userName,
        password: password,
      );
      final response = await _apiService.signIn(request);
      _isAuthenticated = true;
      await getCurrentUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
      _isAuthenticated = false;
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String roleName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = CreateUserRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        roleName: roleName,
      );
      await _apiService.createUser(request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
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
      final request = EditUserRequest(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
      );
      await _apiService.editUser(request);
      await getCurrentUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractErrorMessage(e);
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
      _error = 'New password and confirmation do not match';
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
      final request = ChangePasswordRequest(
        id: id,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      await _apiService.changePassword(request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}