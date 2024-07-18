import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase/controllers/event_controller.dart';
import 'package:new_firebase/models/event.dart';
import 'package:new_firebase/views/screens/notification_screen.dart';
import 'package:new_firebase/views/widgets/drawer_widget.dart';
import 'package:new_firebase/views/widgets/evets_item.dart';
import 'package:new_firebase/views/widgets/tadbir_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventController = Provider.of<EventController>(context);

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.orange.shade300,
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.circle_notifications_rounded,
              size: 40,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase().trim();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tadbirlarni izlash',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Builder(
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            final RenderBox button =
                                context.findRenderObject() as RenderBox;
                            final RenderBox overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;
                            final RelativeRect position = RelativeRect.fromRect(
                              Rect.fromPoints(
                                button.localToGlobal(Offset.zero,
                                    ancestor: overlay),
                                button.localToGlobal(
                                    button.size.bottomRight(Offset.zero),
                                    ancestor: overlay),
                              ),
                              Offset.zero & overlay.size,
                            );
                            showMenu(
                              context: context,
                              position: position,
                              items: const [
                                PopupMenuItem(
                                  child: Text("Search by Event Name"),
                                  value: 1,
                                ),
                                PopupMenuItem(
                                  child: Text("Search by Location"),
                                  value: 2,
                                ),
                              ],
                            ).then((value) {
                              if (value == 1) {
                                _searchByName();
                                _searchController.clear();
                              } else if (value == 2) {
                                _searchByLocation();
                                _searchController.clear();
                              }
                            });
                          },
                          child: const Icon(CupertinoIcons.settings),
                        );
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Yaqin 7 kun ichida',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(
            height: 230,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: PageView.builder(
                itemCount: eventController.events.length,
                itemBuilder: (context, index) {
                  final event = eventController.events[index];
                  return TadbirItem(
                    event: event,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Barcha tadbirlar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Builder(
            builder: (context) {
              final List<Event> filteredEvents = _searchQuery.isEmpty
                  ? eventController.events
                  : eventController.events
                      .where((event) =>
                          event.name.toLowerCase().contains(_searchQuery) ||
                          event.locationName
                              .toLowerCase()
                              .contains(_searchQuery))
                      .toList();

              return Expanded(
                child: eventController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return EvetsItem(event: event);
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _searchByName() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase().trim();
    });
    EventController().searchEventsByName(_searchQuery);
  }

  void _searchByLocation() {
    setState(() {
      EventController().searchEventsByLocation(_searchQuery);
      _searchQuery = _searchController.text.toLowerCase().trim();
    });
  }
}
