// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_firebase/controllers/event_controller.dart';
import 'package:new_firebase/models/event.dart';
import 'package:new_firebase/views/screens/eventInfo_screen.dart';

class ParticipatedEvents extends StatelessWidget {
  const ParticipatedEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final eventController = Provider.of<EventController>(context);

    return Scaffold(
      body: FutureBuilder<List<Event>>(
        future: eventController.fetchUserEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching events.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events participated in yet.'));
          } else {
            final userEvents = snapshot.data!;
            return ListView.builder(
              itemCount: userEvents.length,
              itemBuilder: (context, index) {
                final event = userEvents[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text(event.locationName),
                  trailing: Text('Members: ${event.members}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventInfoScreen(event: event),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
