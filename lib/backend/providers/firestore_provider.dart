import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/models/user_model.dart';
import 'package:hiring_competition_app/backend/services/firestore_services.dart';

class FirestoreProvider extends ChangeNotifier {

  FirestoreServices _firestoreServices = FirestoreServices();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _name = 'random';
  String? get name => _name;

  List<Map<String, dynamic>>? _data;
  List<Map<String, dynamic>>? get data => _data;

  Map<String, dynamic>? _userDetails;
  Map<String, dynamic>? get userDetails => _userDetails;

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

  Future<void> getNickName(User? user) async {
    try {
      _isLoading = true;
      notifyListeners();

      final name = await _firestoreServices.getNickName(user!);
      _isLoading = false;
      _name = name!;
      notifyListeners();

    } catch(e) {
      _isLoading = false;
      notifyListeners();
    } 
  }

  // Get Top Picks
  Stream<QuerySnapshot> getTopPicks(String passedOutYear) {
    return _firestoreServices.getTopPicks(passedOutYear);
  }

  // Get Opportunities
  Stream<QuerySnapshot> getOpportunities(String batch) {
    return _firestoreServices.getOpportunities(batch);
  }

  // Get Internships
  Stream<QuerySnapshot> getInternships(String batch) {
    return _firestoreServices.getInternships(batch);
  }

  // Get Jobs
  Stream<QuerySnapshot> getJobs(String batch) {
    return _firestoreServices.getJobs(batch);
  }

  // Get Competitions
  Stream<QuerySnapshot> getCompetitions(String batch) {
    return _firestoreServices.getCompetitions(batch);
  }

  // Get Hackathons
  Stream<QuerySnapshot> getHackathons(String batch) {
    return _firestoreServices.getHackathons(batch);
  }

  //get toppicks
  Stream<QuerySnapshot> getToppicks(String batch){
    return _firestoreServices.getTopPicks(batch);
  }

  // Get User Stream
  Stream<QuerySnapshot> getUserStream(String uid) {
    return _firestoreServices.getUserStream(uid);
  }

  // Get User Details
  Future<void> getUserDetails(String uid) async {
    try {
      final res = await _firestoreServices.getUserDetails(uid);
      if(res != null) {
        final data = res.data() as Map<String, dynamic>;
        _userDetails = data;
        notifyListeners();
      }
    } catch(e) {
      print(e);
    }
  }

  // Get Applied Opportunities
  Stream<QuerySnapshot> getAppliedOpportunities(String uid) {
    return _firestoreServices.getAppliedOpportunities(uid);
  }

  // Get Applied Opportunity Details
  Future<void> getAppliedOpportunityDetails(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await _firestoreServices.getAppliedOpportunityDetails(userId);
      _data = res;
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      print(e);
    }
  }
}