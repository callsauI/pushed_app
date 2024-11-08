import 'package:flutter/material.dart';
import 'package:pushed_app/message_database.dart';

class AllMessagesPage extends StatelessWidget {
  final MessageDatabase database;

  const AllMessagesPage({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Messages")),
      body: FutureBuilder<List<Message>>(
        future: database.getAllMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No messages found"));
          } else {
            final messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.title),
                  subtitle: Text(message.body),
                  trailing: Text(
                    message.timestamp.toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
