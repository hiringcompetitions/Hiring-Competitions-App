import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiring_competition_app/constants/error_formatter.dart';

import '../services/firebase_services/auth_services.dart';

class CustomAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  User? _user;

  bool? get isLoading => _isLoading;
  User? get user => _user;
 
  Future<String?> googleLogin() async {
    _isLoading = true;
    notifyListeners();

    final user = await _authService.googleLogin();
    _isLoading = false;
    notifyListeners();

    if(user["response"] != null && !(user["response"] is String)) {
      _user = user["response"];
      return null;
    } else {
      return user["response"];
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final val = await _authService.login(email, password);
      _isLoading = false;

      if(val["response"] is User) {
        _user = user;
        notifyListeners();
        return null;
      } else {
        notifyListeners();
        print(val["response"] is FirebaseAuthException);
        return ErrorFormatter().formatAuthError(val["response"]);
      }
    } catch(err) {
      return "An Unexpected error occured. Please try again later";
    }
  }

  Future<String?> createAccount(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    final user = await _authService.createAccount(email, password);

    if (!(user["response"] is String)) {
      await user["response"].updateDisplayName(name);
      await user["response"].reload();
      _user = FirebaseAuth.instance.currentUser; // safer

      print("Updated display name: ${_user?.displayName}");

      _isLoading = false;
      notifyListeners();
      return null;
    } else {
      _isLoading = false;
      notifyListeners();
      return user["response"];
    }
  }

  void signout() async {
    await _authService.signout();
  }
  
  void loadUser() {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }
}