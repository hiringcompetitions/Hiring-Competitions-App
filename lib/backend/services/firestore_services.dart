import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/models/user_model.dart';
import 'package:hiring_competition_app/constants/error_formatter.dart';

class FirestoreServices {
  // Instance
  final _firebaseFirestore = FirebaseFirestore.instance;

  // Create User
  Future<String?> createUser(UserModel user) async {
    try {
      await _firebaseFirestore
          .collection("Users")
          .doc(user.uid)
          .set(user.toMap());
      return null;
    } catch (e) {
      final err = ErrorFormatter().formatFirestoreError(e);
      return err;
    }
  }

  // Get FCM token
  Future<String?> getFcmToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  // Get NickName
  Future<String?> getNickName(User user) async {
    try {
      final docSnapshot =
          await _firebaseFirestore.collection("Users").doc(user.uid).get();
      return docSnapshot.data()?["nickName"];
    } catch (e) {
      return null;
    }
  }

  // Get top picks stream
  Stream<QuerySnapshot> getTopPicks(String batch) {
    try {
      return _firebaseFirestore
          .collection("Opportunities")
          .where("isTopPick", isEqualTo: true)
          .where("isActive", isEqualTo: true)
          .where("eligibility", arrayContains: batch)
          .snapshots();
    } catch (e) {
      print("Error fetching top picks: $e");
      return Stream.empty();
    }
  }

  // Get Opportunities
  Stream<QuerySnapshot> getOpportunities(String batch) {
    debugPrint(batch);
    return _firebaseFirestore
        .collection("Opportunities")
        .where("isActive", isEqualTo: true)
        .where("eligibility", arrayContains: batch)
        .snapshots();
  }

  // Get Internships
  Stream<QuerySnapshot> getInternships(String batch) {
    return _firebaseFirestore
        .collection("Opportunities")
        .where("isActive", isEqualTo: true)
        .where("eligibility", arrayContains: batch)
        .where("category", isEqualTo: "Internship")
        .snapshots();
  }

  // Get Jobs
  Stream<QuerySnapshot> getJobs(String batch) {
    return _firebaseFirestore
        .collection("Opportunities")
        .where("isActive", isEqualTo: true)
        .where("eligibility", arrayContains: batch)
        .where("category", isEqualTo: "Job")
        .snapshots();
  }

  // Get Competitions
  Stream<QuerySnapshot> getCompetitions(String batch) {
    return _firebaseFirestore
        .collection("Opportunities")
        .where("isActive", isEqualTo: true)
        .where("eligibility", arrayContains: batch)
        .where("category", isEqualTo: "Competition")
        .snapshots();
  }

  // Get hackathons
  Stream<QuerySnapshot> getHackathons(String batch) {
    return _firebaseFirestore
        .collection("Opportunities")
        .where("isActive", isEqualTo: true)
        .where("eligibility", arrayContains: batch)
        .where("category", isEqualTo: "Hackathon")
        .snapshots();
  }

  //get top picks opportunities
  Stream<QuerySnapshot> getToppicks(String batch) {
    return _firebaseFirestore
        .collection("Opportunities")
        .where("isActive", isEqualTo: true)
        .where("eligibility", arrayContains: batch)
        .where("isTopPick", isEqualTo: true)
        .snapshots();
  }

  // Get User Stream
  Stream<QuerySnapshot> getUserStream(String uid) {
    return _firebaseFirestore
        .collection("Users")
        .where("uid", isEqualTo: uid)
        .limit(1)
        .snapshots();
  }

  // Get User Details
  Future<DocumentSnapshot?> getUserDetails(String uid) async {
    try {
      final docSnapshot =
          await _firebaseFirestore.collection("Users").doc(uid).get();
      return docSnapshot;
    } catch (e) {
      return null;
    }
  }

  // Get Applied Opportunities
  Stream<QuerySnapshot> getAppliedOpportunities(String uid) {
    return _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("Applied")
        .snapshots();
  }

  // Get Applied Opportunity details
  Future<List<Map<String, dynamic>>?> getAppliedOpportunityDetails(
      String userId) async {
    try {
      final appliedSnapshot = await _firebaseFirestore
          .collection("Users")
          .doc(userId)
          .collection("Applied")
          .get();

      final List<String> appliedDocIds = appliedSnapshot.docs.map((doc) {
        return doc.id;
      }).toList();

      // Fetching job details for each applied job
      List<Map<String, dynamic>> appliedJobs = [];

      for (String docId in appliedDocIds) {
        final opportunityDoc = await _firebaseFirestore
            .collection("Opportunities")
            .doc(docId)
            .get();
        final doc = await _firebaseFirestore
            .collection("Users")
            .doc(userId)
            .collection("Applied")
            .doc(docId)
            .get();

        final data = doc.data();
        final status = data?['status'] ?? 'null';
        final appliedOn = data?['appliedOn'] ?? '';

        if (opportunityDoc.exists) {
          final data = opportunityDoc.data() as Map<String, dynamic>;
          data['status'] = status;
          data['appliedOn'] = appliedOn;
          appliedJobs.add(data);
        }
      }

      return appliedJobs.isEmpty ? null : appliedJobs;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
