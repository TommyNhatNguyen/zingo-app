import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  // 1. Storage for the single, internal instance
  static final NotificationService _instance = NotificationService._internal();

  // 2. A public factory constructor that returns the single instance
  factory NotificationService() {
    return _instance;
  }

  // 3. A private named constructor to prevent external instantiation
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<NotificationSettings?> requestPermission({
    bool alert = true,
    bool announcement = true,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = true,
    bool provisional = false,
    bool sound = true,
  }) async {
    try {
      return await _firebaseMessaging.requestPermission(
        alert: alert,
        announcement: announcement,
        badge: badge,
        carPlay: carPlay,
        criticalAlert: criticalAlert,
        provisional: provisional,
        sound: sound,
      );
    } catch (_) {
      return null;
    }
  }

  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (_) {
      return null;
    }
  }

  Future<NotificationSettings?> getSettings() async {
    try {
      return await _firebaseMessaging.getNotificationSettings();
    } catch (_) {
      return null;
    }
  }
}
