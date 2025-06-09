import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/services/search_service.dart';

class SearchProvider with ChangeNotifier {
  final SearchService _searchService=SearchService();

  List<String> _results = [];
  List<String> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _results = await _searchService.searchJobs(query);
    } catch (e) {
      print("Search error: $e");
      _results = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
