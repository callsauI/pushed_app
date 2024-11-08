import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pushed_messaging/flutter_pushed_messaging.dart';
import 'package:pushed_app/main.dart';
import 'package:pushed_app/message_database.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final MessageDatabase _database = MessageDatabase();

  String _title = '';
  String _body = '';
  String _token = '';
  ServiceStatus _status = FlutterPushedMessaging.status;

  @override
  void initState() {
    super.initState();
    _initializeMessaging();
  }

  void _initializeMessaging() {
    FlutterPushedMessaging.onMessage().listen((message) async {
      setState(() {
        if (message["data"] is Map) {
          _title = message["data"]["title"] ?? "No Title";
          _body = message["data"]["body"] ?? "No Content";
        } else {
          _title = "Notification";
          _body = message["data"].toString();
        }
      });

      // Show local notification with the received message
      await showLocalNotification(_title, _body);

      // Optionally, save the message to the database
      await _database.insertMessage(_title, _body);
    });

    FlutterPushedMessaging.onStatus().listen((status) {
      setState(() {
        _status = status;
      });
    });

    setState(() {
      _token = FlutterPushedMessaging.token ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pushed Messaging Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Service Status: $_status"),
            Text("Title: $_title"),
            Text("Body: $_body"),
            Text("Token: $_token"),
            _buildButton("Copy Token", () async {
              await Clipboard.setData(ClipboardData(text: _token));
            }),
            _buildButton("Show All Messages", () async {
              final savedMessages = await _database.getAllMessages();
              for (var message in savedMessages) {
                print("Saved Message: ${message.title} - ${message.body}");
              }
            }),
            if (Platform.isAndroid)
              _buildButton("Reconnect", FlutterPushedMessaging.reconnect),
            if (!kReleaseMode)
              _buildButton("Get Log", () async {
                final log = await FlutterPushedMessaging.getLog() ?? "";
                await Clipboard.setData(ClipboardData(text: log));
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Future<void> showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'push_channel', // id
      'Push Notifications', // title
      channelDescription: 'This channel is used for push notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
