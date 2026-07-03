import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  /// Demande l'autorisation (Android 13+)
  static Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Retourne le token FCM
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}