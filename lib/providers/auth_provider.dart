import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../models/auth_models.dart';
import '../models/user_models.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;

  AuthProvider() {
    _loadTokens();
  }

  Future<void> _loadTokens() async {
    await _api.loadTokens();
    _isAuthenticated = _api.isAuthenticated;
    if (_isAuthenticated) {
      _currentUser = await _api.getCurrentUser();
    }
    notifyListeners();
  }

  String? _parseError(dynamic e) {
    if (e.toString().contains('Email') || e.toString().contains('email')) {
      return 'This email is already registered';
    }
    return e.toString().replaceAll('Exception:', '').trim();
  }

  // Register + Login
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

      if (_currentUser == null) {
        debugPrint('⚠️ Retrying user load...');
        await Future.delayed(const Duration(milliseconds: 800));
        _currentUser = await _api.getCurrentUser();
      }

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

  // Login Method (used by LoginPage)
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.signIn(SignInRequest(userName: email, password: password));
      _currentUser = await _api.getCurrentUser();

      if (_currentUser == null) {
        await Future.delayed(const Duration(milliseconds: 500));
        _currentUser = await _api.getCurrentUser();
      }

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

  // Logout
  Future<bool> logout() async {
    try {
      await _api.logout();
      _isAuthenticated = false;
      _currentUser = null;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update Profile
  Future<bool> updateProfile(EditUserRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.editUser(request);
      _currentUser = await _api.getCurrentUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change Password (used by ChangePasswordPage)
  Future<bool> changePassword(ChangePasswordRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.changePassword(request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}