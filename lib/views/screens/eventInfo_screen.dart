import 'package:flutter/material.dart';
import 'package:new_firebase/models/event.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_firebase/services/event_http_service.dart';
import 'package:new_firebase/views/widgets/moddalsheet.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventInfoScreen extends StatefulWidget {
  final Event event;
  const EventInfoScreen({super.key, required this.event});

  @override
  State<EventInfoScreen> createState() => _EventInfoScreenState();
}

class _EventInfoScreenState extends State<EventInfoScreen> {
  late GoogleMapController mapController;
  int number = 0;
  bool isJoinde = false;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _incrementMembers(int number) async {
    try {
      await EventHttpService().incrementEventMembers(widget.event.id);
      setState(() {
        widget.event.members += number;
      });
    } catch (e) {
      print('Error incrementing members: $e');
    }
  }

  Future<void> _decrementMembers(int number) async {
    try {
      await EventHttpService().decrementEventMembers(widget.event.id);
      setState(() {
        widget.event.members -= number;
      });
    } catch (e) {
      print('Error incrementing members: $e');
    }
  }

  void _showModifyMembersDialog() async {
    final responce = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Moddalsheet(
          event: widget.event,
        );
      },
    );
    if (responce != null) {
      number = responce['number'];
      _incrementMembers(number);
      isJoinde = !isJoinde;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.event.imageUrl),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.date_range,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    DateFormat('EEEE, yyyy-MM-dd').format(
                      widget.event.time.toDate(),
                    ),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Text(
                      widget.event.locationName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.event.description,
                style: const TextStyle(fontSize: 23),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Members: ${widget.event.members}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 20),
              const Text(
                'Event Location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300,
                ),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.event.geoPoint.latitude,
                      widget.event.geoPoint.longitude,
                    ),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(widget.event.id),
                      position: LatLng(
                        widget.event.geoPoint.latitude,
                        widget.event.geoPoint.longitude,
                      ),
                      infoWindow: InfoWindow(
                        title: widget.event.name,
                        snippet: widget.event.locationName,
                      ),
                    ),
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isJoinde
                  ? ZoomTapAnimation(
                      onTap: () {
                        _decrementMembers(number);
                        isJoinde = !isJoinde;
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red.shade300,
                        ),
                        child: const Text(
                          "Otmena",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  : ZoomTapAnimation(
                      onTap: _showModifyMembersDialog,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange.shade300,
                        ),
                        child: const Text(
                          "Join Event",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
