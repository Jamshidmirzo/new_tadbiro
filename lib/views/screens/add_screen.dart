import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:new_firebase/controllers/event_controller.dart';
import 'package:new_firebase/models/event.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  File? imageFile;
  LatLng? selectedLocation;
  GoogleMapController? mapController;
  String? locationName; // Added locationName field
  bool _isLoading = false; // Add loading state

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
    );
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> onMapTapped(LatLng location) async {
    setState(() {
      selectedLocation = location;
    });
    await _getPlaceName(location);
  }

  Future<void> _getPlaceName(LatLng location) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark place = placeMarks[0];
      setState(() {
        locationName =
            "${place.subLocality}, ${place.street}, ${place.locality}";
      });
    } catch (e) {
      print("Error getting place name: $e");
      setState(() {
        locationName = '';
      });
    }
  }

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  void save() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final eventController =
          Provider.of<EventController>(context, listen: false);

      Event newEvent = Event(
        id: '',
        locationName: locationName ?? '',
        creatorId: FirebaseAuth.instance.currentUser!.uid,
        name: nameController.text,
        time: Timestamp.fromDate(
          DateTime.parse(dateController.text),
        ),
        geoPoint:
            GeoPoint(selectedLocation!.latitude, selectedLocation!.longitude),
        description: descController.text,
        imageUrl: '',
      );

      await eventController.addEvent(newEvent, imageFile!);
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Add Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name of Event',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  readOnly: true,
                  onTap: selectDate,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.timelapse_sharp, size: 40),
                    labelText: 'Description of Event',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 6,
                      child: Container(
                        width: 170,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton.icon(
                          onPressed: openCamera,
                          label: const Text("Camera"),
                          icon: const Icon(Icons.camera),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 6,
                      child: Container(
                        width: 170,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton.icon(
                          onPressed: openGallery,
                          label: const Text("Gallery"),
                          icon: const Icon(Icons.photo),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (imageFile != null)
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(imageFile!),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Select Location',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                  ),
                  child: GoogleMap(
                    onMapCreated: onMapCreated,
                    onTap: (argument) async {
                      return onMapTapped(argument);
                    },
                    initialCameraPosition: CameraPosition(
                      target: selectedLocation ?? LatLng(41.3111, 69.2401),
                      zoom: 10,
                    ),
                    markers: selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selected-location'),
                              position: selectedLocation!,
                            )
                          }
                        : {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
