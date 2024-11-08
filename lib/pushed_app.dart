import 'package:flutter/material.dart';
import 'package:pushed_app/presentation/pages/notification_page.dart';

class PushedApp extends StatelessWidget {
  const PushedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotificationPage(),
    );
  }
}
