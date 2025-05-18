// ignore_for_file: unused_field, unused_catch_clause

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hiring_competition_app/constants/error_formatter.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(e) {
      String err = ErrorFormatter().formatAuthError(e);
      Flushbar(
        title: err,
      );
      return null;
    }
  }

  // Create Account
  Future<User?> createAccount(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(e) {
      throw Exception(e.toString());
    }
  }

  // Google Login
  Future<User?> googleLogin() async {
    try {
      // trigger authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if(googleUser == null) return null; 

      // Obtain the details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Creating a new Credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      final userCredential = await auth.signInWithCredential(credential);

      return userCredential.user;
    } catch(e) {
      print(ErrorFormatter().formatAuthError(e.toString()));
      return null;
    }
  }

  // Signout
  Future signout() async {
    try {
      await auth.signOut();
    } catch(e) {
      print(e);
    }
  } 
}