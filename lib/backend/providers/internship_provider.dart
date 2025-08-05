import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hiring_competition_app/backend/models/application_model.dart';
import 'package:hiring_competition_app/backend/services/intership_service.dart';

class InternshipProvider extends ChangeNotifier {
  final InternshipService _intershipService = InternshipService();

  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  Map<String, dynamic>? _details;
  Map<String, dynamic>? get details => _details;

  String _errormessage = "";
  String get errormessage => _errormessage;

  Future<void> getdetails(String name) async {
    try {
      _isLoading=true;
      notifyListeners();
      final result = await _intershipService.getdetails(name);
      if (result != null) {
        _details = result;
        _isLoading = false;
        _errormessage = "";
        notifyListeners();
      } else {
        _details = null;
        _errormessage = "No details found for \"$name\".";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _details = null;
      _errormessage = "Failed to fetch details: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add Application
  Future<String?> addApplication(String uid, ApplicationModel application, String userUID) async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await _intershipService.addApplication(uid, application, userUID);
      return res;
    } catch(e) {
      return "An Unexpected error occured. Please try again later";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get Application Status
  Stream<DocumentSnapshot> getAppliedStatus(String userUID, String opportunityUID) {
    return  _intershipService.getAppliedStatus(userUID, opportunityUID);
  }

  // Update Applied Status
  Future<void> updateStatus(String userUID, String opportunityUID, String status) async {
    try {
      await _intershipService.updateAppliedStatus(userUID, opportunityUID, status);
    } catch(e) {
      print(e);
    }
  }
}