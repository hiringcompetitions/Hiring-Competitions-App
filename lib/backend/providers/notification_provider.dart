import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/services/notification_services.dart';

class NotificationProvider extends ChangeNotifier {
  // instance
  NotificationServices _services = new NotificationServices();

  // Setup
  Future<void> setupNotifications() async {
    _services.initializeNotifications();
    await _services.requestPermission();
    _services.listen();
    await _services.subscribeToTopic("General");
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
}