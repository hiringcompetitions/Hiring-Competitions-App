
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<String>> searchJobs(String query) async {
    final snapshot = await _db.collection('Opportunities').get();

    final results = snapshot.docs
        .where((doc) {
          final title = doc['title']?.toString().toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        })
        .map((doc) => doc['title'].toString())
        .toList();

    return results;
  }
}