import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiring_competition_app/backend/models/application_model.dart';

class InternshipService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getdetails(String name) async {
    try {
      final snapshot = await _firestore
          .collection('Opportunities')
          .where('title', isEqualTo: name)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        throw Exception("Event Not Found");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Add Application
  Future<String?> addApplication(String uid, ApplicationModel application, String userUID) async {
    try {
      await _firestore.collection("Opportunities").doc(uid).collection("Applicants").doc(userUID).set(application.toMap());

      await _firestore.collection("Users").doc(userUID).collection("Applied").doc(uid).set({
        'appliedOn' : Timestamp.now(),
        'status' : 'Applied',
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Get Applied Status
  Stream<DocumentSnapshot> getAppliedStatus(String userUID, String opportunityUID) {
    return _firestore.collection("Users").doc(userUID).collection("Applied").doc(opportunityUID).snapshots();
  }

  // Update Applied Statuss
  Future<void> updateAppliedStatus(String userUID, String opportunityUID, String status) async {
    try {
      await _firestore.collection("Users").doc(userUID).collection("Applied").doc(opportunityUID).update({
        "status" : status,
      });

      await _firestore.collection("Opportunities").doc(opportunityUID).collection("Applicants").doc(userUID).update(
        {
          "status" : status,
        }
      );
    } catch(e) {
      print(e);
    }
  }
}