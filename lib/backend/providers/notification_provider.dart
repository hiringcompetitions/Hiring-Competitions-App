import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  // instance
  NotificationServices _services = new NotificationServices();

  // Is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>>? _notifications;
  List<Map<String, dynamic>>? get notifications => _notifications;

  // Setup
  Future<void> setupNotifications() async {
    _services.initializeNotifications();
    await _services.requestPermission();
    _services.listen();
    await _services.subscribeToTopic("general");
  }

  // subscribe
  Future<void> subscribeToTopic(String topic) async {
    await _services.subscribeToTopic(topic);
  }

  // unsubscribe to topics
  Future<void> unsubscribeToTopics() async {
    await _services.unSubscribeToTopics();
  }

  // listen
  void listen() {
    _services.listen();
  }

  // Get Notification Data
  Future<void> getStoredNotifications() async {
    try {

      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString('notifications');

      if (data != null) {
        final res = List<Map<String, dynamic>>.from(jsonDecode(data));
        print(res);
        _notifications = res;
        notifyListeners();
      }
    } catch(e) {
      print("ERRORR");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String name) async {
    
  }

  // Clear Notifications
  Future<void> clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    _notifications = null;
    notifyListeners(); // Removes the key and its value
  }
}