import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/models/user_model.dart';
import 'package:hiring_competition_app/backend/services/firestore_services.dart';

class FirestoreProvider extends ChangeNotifier {

  FirestoreServices _firestoreServices = FirestoreServices();

  bool _isLoading = false;
  bool? get isLoading => _isLoading;

  Future<String?> addUser(UserModel user) async {

    _isLoading = true;
    notifyListeners();

    try {
      final res = await _firestoreServices.createUser(user);
      _isLoading = false;
      notifyListeners();

      return res;
    } catch(e) {
      return "An unknown error occured";
    }
  }

  Future<String?> getFcmToken() async {
    try {
      final res = await _firestoreServices.getFcmToken();
      return res;
    } catch(e) {
      return null;
    }
  }
}