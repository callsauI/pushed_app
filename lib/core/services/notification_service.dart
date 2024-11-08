import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class NotificationService {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const channel = AndroidNotificationChannel(
      'push_channel',
      'MY CHANNEL FOR PUSH',
      description: 'This channel is used for push messages',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await perm.Permission.notification.request();
  }

  static Future<void> showNotification(Map<dynamic, dynamic> message) async {
    final title = message["data"]["title"] ?? "No Title";
    final body = message["data"]["body"] ?? "No Content";

    await _flutterLocalNotificationsPlugin.show(
      8888,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'push_channel',
          'MY CHANNEL FOR PUSH',
          icon: 'launch_background',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
