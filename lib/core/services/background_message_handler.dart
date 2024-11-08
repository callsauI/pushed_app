import 'package:flutter/widgets.dart';
import 'package:pushed_app/message_database.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(Map<dynamic, dynamic> message) async {
  WidgetsFlutterBinding.ensureInitialized();
  final MessageDatabase _database = MessageDatabase();
  const title = "Notification";
  final body = message["data"] ?? "No Content";
  await NotificationService.showNotification(title, body);

  await _database.insertMessage(title, body);
}
