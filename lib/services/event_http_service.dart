import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> incrementEventMembers(String eventId) async {
    try {
      DocumentReference eventRef = _firebase.collection('events').doc(eventId);
      await _firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(eventRef);
        if (!snapshot.exists) {
          throw Exception('Event does not exist');
        }
        int newMembersCount = (snapshot['members'] as int) + 1;
        transaction.update(eventRef, {'members': newMembersCount});
      });
    } catch (e) {
      print('Error incrementing event members: $e');
    }
  }

  Future<void> decrementEventMembers(String eventId) async {
    try {
      DocumentReference eventRef = _firebase.collection('events').doc(eventId);
      await _firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(eventRef);
        if (!snapshot.exists) {
          throw Exception("Event does not exist");
        }
        int currentMembers = snapshot.get('members') ?? 0;
        if (currentMembers > 0) {
          transaction.update(eventRef, {'members': currentMembers - 1});
        }
      });
    } catch (e) {
      print('Error decrementing members: $e');
    }
  }

  Future<List<Event>> fetchUserEvents() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await _firebase
          .collection('events')
          .where('creator_id', arrayContains: userId)
          .get();

      final userEvents = querySnapshot.docs
          .map((doc) => Event.fromQuerySnapshot(doc))
          .toList();
      return userEvents;
    } catch (e) {
      print('Error fetching user events: $e');
      return [];
    }
  }
}
