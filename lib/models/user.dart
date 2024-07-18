import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_firebase/models/event.dart';

class Users {
  final String id;
  final String uid;
  final String firstName;
  final String email;
  final String imageUrl;

  Users({
    required this.id,
    required this.uid,
    required this.firstName,
    required this.email,
    required this.imageUrl,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] ?? '',
      uid: json['uid'] ?? '',
      firstName: json['first-name'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['image-url'] ?? '',
    );
  }

  factory Users.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Users(
      id: snapshot.id,
      uid: data['uid'] ?? '',
      firstName: data['first-name'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['image-url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'first-name': firstName,
      'email': email,
      'image-url': imageUrl,
    };
  }

  List<Event> getUserEvents(List<Event> events) {
    return events.where((element) => element.creatorId == id).toList();
  }
}
