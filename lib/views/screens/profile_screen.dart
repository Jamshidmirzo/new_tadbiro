// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase/controllers/user_controller.dart';

import 'package:new_firebase/models/user.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void saveProfile() {
    if (formKey.currentState!.validate()) {
      final Users user = Users(
        id: UniqueKey().toString(),
        uid: FirebaseAuth.instance.currentUser!.uid,
        firstName: _nameController.text,
        email: FirebaseAuth.instance.currentUser!.email!,
        imageUrl: _photoController.text,
      );
      final userHttpService = context.read<UserController>();
      userHttpService.addProfile(user).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr('enternameerror');
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: context.tr('entername'),
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _photoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr('enterurlerror');
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: context.tr('enterurl'),
                  prefixIcon: Icon(Icons.photo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProfile,
                child: Text(
                  context.tr('savep'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
