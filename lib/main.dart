// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/backend/providers/internship_provider.dart';
import 'package:hiring_competition_app/constants/theme.dart';
import 'package:hiring_competition_app/firebase_options.dart';
import 'package:hiring_competition_app/views/splash/splashScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>InternshipProvider()),
        ChangeNotifierProvider(create: (_) => CustomAuthProvider()),
        ChangeNotifierProvider(create: (_) => FirestoreProvider()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApptheme(),
      home: Splashscreen(),
    );
  }
}
