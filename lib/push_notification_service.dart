import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_push_notification/local_notification_service.dart';
import 'package:flutter_push_notification/main.dart';

import 'chat_page.dart';
import 'firebase_options.dart';

class PushNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final LocalNotificationService localNotificationService =
      LocalNotificationService();
  Future<NotificationSettings?> requestPermission() async {
    final NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return settings;
  }

  Future<String?> getToken() async {
    return await messaging.getToken();
  }

  Future<void> registerNotification() async {
    final settings = await requestPermission();
    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await getToken();
      debugPrint("Token $token");
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      handleNotification();
      showForegroundNotificationIOS();
      localNotificationService.setUp();
    }
  }

  void handleNotification() {
    FirebaseMessaging.onMessage.listen((message) {
      print('Handling a foreground message: ${message.messageId}');
      localNotificationService.showFlutterNotification(message);
    });
  }

  Future<void> showForegroundNotificationIOS() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // ເຮັດໃຫ້ notification ຖືກສະແດງໃນ foreground state
      badge: true,
      sound: true,
    );
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  void handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => ChatPage(
              sender: message.data['sender'] ?? '',
              message: message.data['message'] ?? '')));
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}
