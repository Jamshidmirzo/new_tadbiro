import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_firebase/controllers/event_controller.dart';
import 'package:new_firebase/views/widgets/evets_item.dart';
import 'package:provider/provider.dart';

class AllEventsTab extends StatefulWidget {
  const AllEventsTab({super.key});

  @override
  State<AllEventsTab> createState() => _AllEventsTabState();
}

class _AllEventsTabState extends State<AllEventsTab> {
  @override
  void initState() {
    super.initState();
    final eventController = context.read<EventController>();
    eventController.fetchEventsByCreatorId(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final eventController = context.watch<EventController>();

    return Scaffold(
      body: eventController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: eventController.userEvents.length,
              itemBuilder: (context, index) {
                final event = eventController.userEvents[index];
                return EvetsItem(event: event);
              },
            ),
    );
  }
}
