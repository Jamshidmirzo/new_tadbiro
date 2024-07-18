import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase/controllers/event_controller.dart';
import 'package:new_firebase/firebase_options.dart';
import 'package:new_firebase/services/localization_service.dart';
import 'package:new_firebase/views/screens/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  await requestPermissions();


  await LocationService.init();

  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  final cameraPermission = await Permission.camera.status;
  final galleryPermission = await Permission.photos.status;
  final locationPermission = await Permission.location.status;

  if (cameraPermission != PermissionStatus.granted) {
    await Permission.camera.request();
  }
  if (locationPermission != PermissionStatus.granted) {
    await Permission.location.request();
  }
  if (galleryPermission != PermissionStatus.granted) {
    await Permission.photos.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventController(),
        ),
      ],
      child: AdaptiveTheme(
        initial: AdaptiveThemeMode.light,
        light: ThemeData(brightness: Brightness.light),
        dark: ThemeData(brightness: Brightness.dark),
        builder: (lightTheme, darkTheme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
