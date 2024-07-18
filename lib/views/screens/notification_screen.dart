import 'package:flutter/material.dart';
import 'package:new_firebase/views/widgets/notification_item.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifiction screen"),
      ),
      body: ListView.builder(
        itemExtent: 130,
        itemCount: 10,
        itemBuilder: (context, index) {
          return NotificationItem();
        },
      ),
    );
  }
}
