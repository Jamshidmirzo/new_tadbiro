import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_firebase/models/user.dart';

class UserHttpService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<void> saveUserProfile(Users user) async {
    try {
      await _firebase.collection('users').add(user.toJson());
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  Future<Users> getUser(String id) async {
    try {
      var snapshot = await _firebase.collection('users').doc(id).get();
      if (snapshot.exists) {
        return Users.fromSnapshot(snapshot);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<Users> getUsersSortedByUid() async {
    try {
      var snapshot = await _firebase
          .collection('users')
          .orderBy('')
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Users.fromSnapshot(doc)).first;
      } else {
        throw Exception('No users found');
      }
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}
