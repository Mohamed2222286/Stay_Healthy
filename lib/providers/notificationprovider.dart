// providers/notification_provider.dart
import 'package:flutter/foundation.dart';

class Notification {
  final String title;
  final String message;

  Notification({required this.title, required this.message});
}

class NotificationProvider extends ChangeNotifier {
  final List<Notification> _notifications = [];

  List<Notification> get notifications => _notifications;

  void addNotification(String title, String message) {
    _notifications.add(Notification(title: title, message: message));
    notifyListeners();
  }
}