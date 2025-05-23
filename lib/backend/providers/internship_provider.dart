import 'package:flutter/foundation.dart';
import 'package:hiring_competition_app/backend/services/firebase_services/intership_service.dart';

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
        _isLoading=false;
        _errormessage = "";
        notifyListeners();
      } else {
        _details = null;
        _errormessage = "No details found for \"$name\".";
      }
    } catch (e) {
      _errormessage = "Failed to fetch details: $e";
      _details = null;
    }

    notifyListeners();
  }
}

