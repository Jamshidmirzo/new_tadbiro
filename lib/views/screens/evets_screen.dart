import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase/controllers/event_controller.dart';
import 'package:new_firebase/views/screens/AllEventsTab.dart';
import 'package:new_firebase/views/screens/CanceledEvents.dart';
import 'package:new_firebase/views/screens/NearEvents.dart';
import 'package:new_firebase/views/screens/ParticipatedEvents.dart';
import 'package:new_firebase/views/screens/add_screen.dart';
import 'package:provider/provider.dart';

class EvetsScreen extends StatefulWidget {
  const EvetsScreen({super.key});

  @override
  State<EvetsScreen> createState() => _EvetsScreenState();
}

class _EvetsScreenState extends State<EvetsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventController = Provider.of<EventController>(context);

    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('My Events'),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'All Events'),
                Tab(text: 'Near Events'),
                Tab(text: 'Participated'),
                Tab(text: 'Canceled'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              AllEventsTab(),
              NearEventsTab(),
              ParticipatedEvents(),
              CanceledEvents(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (ctx) => AddScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
