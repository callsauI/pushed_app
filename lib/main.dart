import 'package:flutter/material.dart';
import 'package:flutter_pushed_messaging/flutter_pushed_messaging.dart';
import 'package:pushed_app/core/services/background_message_handler.dart';
import 'package:pushed_app/core/services/notification_service.dart';
import 'package:pushed_app/pushed_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await FlutterPushedMessaging.init(backgroundMessageHandler);
  runApp(const PushedApp());
}
