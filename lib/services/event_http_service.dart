import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:new_firebase/models/event.dart';

class EventHttpService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseStorage _eventImageStorage = FirebaseStorage.instance;

  Stream<List<Event>> getAllEvents() {
    return _firebase.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromQuerySnapshot(doc)).toList();
    });
  }

  Stream<List<Event>> getEventsByCreatorId(String creatorId) {
    return _firebase
        .collection('events')
        .where('creator-id', isEqualTo: creatorId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromQuerySnapshot(doc)).toList();
    });
  }

  Stream<List<Event>> getNearestEvents(DateTime start, DateTime end) {
    return _firebase
        .collection('events')
        .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('time', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('time')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromQuerySnapshot(doc)).toList();
    });
  }

  Future<void> addEvent(Event event) async {
    try {
      await _firebase.collection('events').add(event.toJson());
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _eventImageStorage.ref().child('events/images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }
}
