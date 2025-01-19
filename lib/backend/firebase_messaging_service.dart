import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // Get the token
      String? token = await _firebaseMessaging.getToken(
        vapidKey: 'BNY8xJDaiK4DRgDyZEu2bCYvBMIsyvuu_87DK2KialtmnoGgWVo_7t6hGLsyvlDyV0kVh9vT-3u9GLxKY9ViHDU', // Add your VAPID key from Firebase Console
      );
      print('FCM Token: $token');

      // Handle incoming messages when the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
        }
      });
    } else {
      print('User declined permission');
    }
  }
}
