import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_firebase/models/event.dart';
import 'package:new_firebase/services/event_http_service.dart';

class EventController extends ChangeNotifier {
  final EventHttpService eventService = EventHttpService();
  List<Event> _events = [];
  List<Event> _userEvents = [];
  List<Event> _nearestEvents = [];
  bool _isLoading = false;
  List<Event> _allEvents = [];

  List<Event> get allEvents => _allEvents;
  List<Event> get events => _events;
  List<Event> get userEvents => _userEvents;
  List<Event> get nearestEvents => _nearestEvents;
  bool get isLoading => _isLoading;

  EventController() {
    fetchAllEvents();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void fetchAllEvents() {
    setLoading(true);
    eventService.getAllEvents().listen((events) {
      _events = events;
      setLoading(false);
      print(eventService.getAllEvents());
    });
  }

  void fetchEventsByCreatorId(String creatorId) {
    setLoading(true);
    eventService.getEventsByCreatorId(creatorId).listen((events) {
      _userEvents = events;
      setLoading(false);
    });
  }

  void fetchNearestEvents(DateTime start, DateTime end) {
    setLoading(true);
    eventService.getNearestEvents(start, end).listen((events) {
      _nearestEvents = events;
      setLoading(false);
    });
  }

  Future<void> addEvent(Event event, File photo) async {
    setLoading(true);
    try {
      String imageUrl = await eventService.uploadImage(photo);
      Event newEvent = Event(
        id: '',
        locationName: event.locationName,
        creatorId: event.creatorId,
        name: event.name,
        time: event.time,
        geoPoint: event.geoPoint,
        description: event.description,
        imageUrl: imageUrl,
      );
      await eventService.addEvent(newEvent);
      _events.add(newEvent);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print("Error adding event: $e");
    }
  }

  List<Event> searchEventsByName(String query) {
    query = query.toLowerCase().trim();

    return _allEvents
        .where((event) => event.name.toLowerCase().contains(query))
        .toList();
  }

  List<Event> searchEventsByLocation(String query) {
    query = query.toLowerCase().trim();
    return _allEvents
        .where(
          (event) => event.locationName.toLowerCase().contains(query),
        )
        .toList();
  }
  
}
