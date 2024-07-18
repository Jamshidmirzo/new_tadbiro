import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase/controllers/event_controller.dart';
import 'package:new_firebase/controllers/user_controller.dart';
import 'package:new_firebase/firebase_options.dart';
import 'package:new_firebase/services/localization_service.dart';
import 'package:new_firebase/views/screens/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  // Request necessary permissions
  await requestPermissions();

  // Initialize Location Service
  await LocationService.init();

  runApp(
    EasyLocalization(
      supportedLocales: const[
        Locale('en'),
        Locale('ru'),
        Locale('uz')
      ],
      path: 'resources/langs/',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.photos,
    Permission.location,
  ].request();
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
        ChangeNotifierProvider(
          create: (context) => UserController(),
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
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
