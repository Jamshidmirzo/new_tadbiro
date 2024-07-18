import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_firebase/services/auth_firebase_service.dart';
import 'package:new_firebase/views/screens/home_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final firebaseservice = AuthFirebaseService();
  bool isLogged = false;

  login() async {
    firebaseservice.register(emailController.text, passController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 250,
                ),
                Text(
                  'O`z shahringizdagi tadbirlar!',
                  style: GoogleFonts.aboreto(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Email",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email kiriting";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Parol",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Parol kiriting";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ZoomTapAnimation(
                  onTap: login,
                  child: Card(
                    elevation: 6,
                    child: Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Kirish",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
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
