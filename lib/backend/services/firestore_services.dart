import 'package:cloud_firestore/cloud_firestore.dart';
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
}