import 'package:flutter/material.dart';
import 'package:new_firebase/models/user.dart';
import 'package:new_firebase/services/user_firebase_httpsevice.dart';

class UserController extends ChangeNotifier {
  UserHttpService userService = UserHttpService();

  Future<void> addProfile(Users user) async {
    await userService.saveUserProfile(user);
    notifyListeners();
  }

  Future<Users> getUser(String id) async {
    return userService.getUser(id);
  }

  Future<Users> getUsersSortedByUid() async {
    return userService.getUsersSortedByUid();
  }
}
