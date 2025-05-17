import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  User? _user;

  bool? get isLoading => _isLoading;
  User? get user => _user;
 
  Future<String?> googleLogin() async {
    _isLoading = true;
    notifyListeners();

    final user = await _authService.googleLogin();
    if(user != null) {
      _user = user;
      _isLoading = false;
      notifyListeners();
      return null;
    } else {
      return 'Google SignIn failed';
    }
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final user = await _authService.login(email, password);

    if(user != null) {
      _user = user;
      _isLoading = false;
      notifyListeners();
      return null;
    } else {
      return 'Login Failed. Please Try again later';
    }
  }

  Future<String?> createAccount(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final user = await _authService.createAccount(email, password);

    if(user != null) {
      _user = user;
      _isLoading = false;
      notifyListeners();
      return null;
    } else {
      return 'Something went wrong. Please try again later';
    }
  }

  void signout() async {
    await _authService.signout();
  }
}