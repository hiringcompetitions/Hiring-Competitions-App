// ignore_for_file: unused_field, unused_catch_clause, unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hiring_competition_app/constants/error_formatter.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return {"response" : userCredential.user};
    } on FirebaseAuthException catch(e) {
      return {"response" : e};
    }
  }

  // Create Account
  Future<Map<String, dynamic>> createAccount(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return {"response" : userCredential.user};
    } on FirebaseAuthException catch(e) {
      final err = ErrorFormatter().formatAuthError(e);
      return {"response" : err};
    }
  }

  // Google Login
  Future<Map<String, dynamic>> googleLogin() async {
    try {
      await FirebaseAuth.instance.signOut();
      // trigger authentication flow
      final GoogleSignInAccount? gUser = await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if(googleUser == null) return {"response" : "Google Signin failed"};
      if(!googleUser.email.endsWith("@vishnu.edu.in")) return {"response" : "Please select your college email address"};

      // Obtain the details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Creating a new Credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      final userCredential = await auth.signInWithCredential(credential);

      if(userCredential.user == null) {
        return {"response" : null};
      }

      return {"response" : userCredential.user};
    } catch(e) {
      print(e.toString());
      return {"response" : e.toString()};
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