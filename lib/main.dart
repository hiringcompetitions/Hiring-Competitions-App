// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/backend/providers/internship_provider.dart';
import 'package:hiring_competition_app/backend/providers/notification_provider.dart';
import 'package:hiring_competition_app/backend/providers/search_provider.dart';
import 'package:hiring_competition_app/constants/theme.dart';
import 'package:hiring_competition_app/firebase_options.dart';
import 'package:hiring_competition_app/views/splash/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Store notification
Future<void> storeNotification(RemoteMessage message,
    {String location = "Unknown"}) async {
  print(location);
  print(StackTrace.current);
  final prefs = await SharedPreferences.getInstance();

  final String? existingData = prefs.getString('notifications');
  List<Map<String, dynamic>> notifications = [];

  if (existingData != null) {
    notifications = List<Map<String, dynamic>>.from(jsonDecode(existingData));
  }

  final newNotification = {
    'title': message.notification?.title,
    'body': message.notification?.body,
    'data': message.data,
    'isOpened': false,
    'timestamp': DateTime.now().toIso8601String(),
  };

  notifications.add(newNotification);
  prefs.setString('notifications', jsonEncode(notifications));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final notificationProvider = NotificationProvider();
  notificationProvider.setupNotifications();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SearchProvider()),
      ChangeNotifierProvider(create: (_) => InternshipProvider()),
      ChangeNotifierProvider(create: (_) => CustomAuthProvider()),
      ChangeNotifierProvider(create: (_) => FirestoreProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ],
    child: MyApp(),
  ));
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
