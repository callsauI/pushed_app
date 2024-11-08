import 'package:flutter/material.dart';
import 'package:flutter_pushed_messaging/flutter_pushed_messaging.dart';
import 'package:pushed_app/core/services/backround_message_handler.dart';
import 'package:pushed_app/core/services/notification_service.dart';
import 'package:pushed_app/pushed_app.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  // await FlutterPushedMessaging.init(backgroundMessageHandler);
  runApp(const PushedApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          'launch_background'); // Replace with your app icon
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
