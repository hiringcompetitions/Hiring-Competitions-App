import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    } catch(e) {
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
    } catch(e) {
      return null;
    }
  }

  // Get NickName
  Future<String?> getNickName(User user) async {
    try {
      final docSnapshot = await _firebaseFirestore.collection("Users").doc(user.uid).get();
      return docSnapshot.data()?["nickName"];
    } catch(e) {
      return null;
    }
  }

  // Get top picks stream
  Stream<QuerySnapshot> getTopPicks() {
    return _firebaseFirestore.collection("TopPicks").snapshots();
  }

  // Get Oppurtunities
  Stream<QuerySnapshot> getOppurtunities() {
    return _firebaseFirestore.collection("Oppurtunities").snapshots();
  }
}