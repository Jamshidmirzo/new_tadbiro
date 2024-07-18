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
      body: eventController.userEvents.isEmpty
          ? const Center(
              child: Text('No events participated in yet.'),
            )
          : ListView.builder(
              itemCount: eventController.userEvents.length,
              itemBuilder: (context, index) {
                final event = eventController.userEvents[index];
                return ListTile(
                  title: Text(
                    event.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Text(event.locationName),
                  trailing: Text(
                    'Members: ${event.members}',
                    
                  ),
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
            ),
    );
  }
}
