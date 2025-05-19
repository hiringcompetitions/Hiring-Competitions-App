import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/models/user_model.dart';
import 'package:hiring_competition_app/backend/services/firestore_services.dart';

class FirestoreProvider extends ChangeNotifier {

  FirestoreServices _firestoreServices = FirestoreServices();

  bool _isLoading = false;
  bool? get isLoading => _isLoading;

  String _name = 'random';
  String? get name => _name;

  Stream<QuerySnapshot>? _topPicksSnapshots = null;
  Stream<QuerySnapshot>? get topPicksSnapshots => _topPicksSnapshots;

  Stream<QuerySnapshot>? _oppurtunitiesSnapshots = null;
  Stream<QuerySnapshot>? get oppurtunitiesSnapshots => _oppurtunitiesSnapshots;

  // Add User

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

  // FCM Token

  Future<String?> getFcmToken() async {
    try {
      final res = await _firestoreServices.getFcmToken();
      return res;
    } catch(e) {
      return null;
    }
  }

  // Get Nick Name

  Future<void> getNickName(User user) async {
    try {
      _isLoading = true;
      notifyListeners();

      final name = await _firestoreServices.getNickName(user);
      _isLoading = false;
      _name = name!;
      notifyListeners();

    } catch(e) {
      _isLoading = false;
      notifyListeners();
    } 
  }

  // Get Top Picks
  void getTopPicks() {
    _isLoading = true;
    notifyListeners();
    _topPicksSnapshots = _firestoreServices.getTopPicks();
    _isLoading = false;
    notifyListeners();
  }

  // Get Oppurtunities
  void getOppurtunities() {
    _isLoading = true;
    notifyListeners();
    _oppurtunitiesSnapshots = _firestoreServices.getOppurtunities();
    _isLoading = false;
    notifyListeners();
  }
}