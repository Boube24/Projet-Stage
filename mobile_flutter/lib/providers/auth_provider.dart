import 'package:flutter/material.dart';
import '../core/storage/local_storage.dart';
import '../models/user_model.dart';
import '../core/service/firebase_service.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _error;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // تم إصلاح دالة التسجيل وحذف التكرار والتداخل
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
      );

      _isAuthenticated = false;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.login(
        email: email,
        password: password,
      );

      _user = await _authService.getProfile();

      final token = await FirebaseService.getToken();
      if (token != null) {
        await _authService.updateFcmToken(token);
      }

      _isAuthenticated = true;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    _error = null;
    final token = await LocalStorage.getToken();

    if (token == null) {
      _isAuthenticated = false;
      notifyListeners();
      return;
    }

    try {
      _user = await _authService.getProfile();
      _isAuthenticated = true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _user = null;
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _error = null;
    await _authService.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
} // قوس إغلاق الكلاس الأساسي