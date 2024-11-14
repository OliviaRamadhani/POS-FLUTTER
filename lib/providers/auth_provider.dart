import 'package:flutter/material.dart';
import '../services/auth_api.dart';

class AuthProvider with ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    try {
      await _authApi.login(email, password);
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      rethrow;
    }
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
