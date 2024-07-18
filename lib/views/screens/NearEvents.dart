import 'package:flutter/material.dart';
import 'package:new_firebase/controllers/event_controller.dart';
import 'package:new_firebase/views/widgets/evets_item.dart';
import 'package:provider/provider.dart';

class NearEventsTab extends StatefulWidget {
  const NearEventsTab({super.key});

  @override
  State<NearEventsTab> createState() => _NearEventsTabState();
}

class _NearEventsTabState extends State<NearEventsTab> {
  @override
  void initState() {
    super.initState();
    final eventController = context.read<EventController>();
    final now = DateTime.now();
    final threeDaysFromNow = now.add(Duration(days: 3));
    eventController.fetchNearestEvents(now, threeDaysFromNow);
  }

  @override
  Widget build(BuildContext context) {
    final eventController = context.watch<EventController>();

    return Scaffold(
      body: eventController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: eventController.nearestEvents.length,
              itemBuilder: (context, index) {
                final event = eventController.nearestEvents[index];
                return EvetsItem(event: event);
              },
            ),
    );
  }
}
