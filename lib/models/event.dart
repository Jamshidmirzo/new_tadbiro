import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String creatorId;
  final String name;
  final Timestamp time;
  final GeoPoint geoPoint;
  final String description;
  final String imageUrl;
  final String locationName;
   int members; // New field

  Event({
    required this.locationName,
    required this.id,
    required this.creatorId,
    required this.name,
    required this.time,
    required this.geoPoint,
    required this.description,
    required this.imageUrl,
    this.members = 0, // Default value
  });

  factory Event.fromQuerySnapshot(QueryDocumentSnapshot<Object?> snapshot) {
    return Event(
      locationName: snapshot['locationName'],
      id: snapshot.id,
      creatorId: snapshot['creator-id'] as String,
      name: snapshot['name'] as String,
      time: snapshot['time'] as Timestamp,
      geoPoint: snapshot['geo-point'] as GeoPoint,
      description: snapshot['description'] as String,
      imageUrl: snapshot['image-url'] as String,
      members: snapshot['members'] ?? 0, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'creator-id': creatorId,
      'name': name,
      'time': time,
      'geo-point': geoPoint,
      'description': description,
      'image-url': imageUrl,
      'members': members, // Add members to JSON
    };
  }
}
